Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:51232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752033Ab0IXLu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 07:50:56 -0400
Date: Fri, 24 Sep 2010 13:51:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 3/6] SoC Camera: add driver for OV6650 sensor
In-Reply-To: <201009241336.34277.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1009241347450.14966@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009240045.24669.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009240811280.14966@axis700.grange>
 <201009241336.34277.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 24 Sep 2010, Janusz Krzysztofik wrote:

> Friday 24 September 2010 08:52:32 Guennadi Liakhovetski napisał(a):
> > On Fri, 24 Sep 2010, Janusz Krzysztofik wrote:
> > > Thursday 23 September 2010 18:06:15 Guennadi Liakhovetski napisał(a):
> > > > On Wed, 22 Sep 2010, Janusz Krzysztofik wrote:
> > > > > Wednesday 22 September 2010 11:12:46 Guennadi Liakhovetski napisaÅ
> (a):
> > > > > > On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> 
> ...
> > > > whereas COMA and COML select
> > > > whether to scale it to a CIF or to a QCIF output.
> > >
> > > I think the answer is: not exactly. AFAICT, the COMA_QCIF bit selects
> > > whether to scale it down by 2 (QCIF selection) or not (CIF selection).
> >
> > Ah! Ok, that it would be better to select different names for those bits.
> 
> I was trying to keep all names more or less consistent with the wording used 
> in the sensor documentation (which doesn't follow the v4l2 specification 
> unfortunately :). In this case we have:
> 
> COMA  Common Control A
> 	...
> 	Bit[5]: Output format – resolution
> 		0: CIF (352 x 288)
> 		1: QCIF (176 x 144)
> 
> So I could rename it to something like COMA_OUTFMT or COMA_RESOLUTION. Which 
> one sounds better for you?

ok, so, it means to which output window the _complete_ sensor area is 
mapped. And if you get a smaller sensor rectangle, you get a smaller 
output image, right? Ok, then you can just leave it as is.

> ...
> > > > But I think your driver might have a problem with its cropping /
> > > > scaling handling. Let's see if I understand it right:
> > > >
> > > > 1. as cropcap you currently return QCIF or CIF, depending on the last
> > > > S_FMT,
> > >
> > > Yes.
> > >
> > > BTW, my S_FMT always calls ov6650_reset(), which resets the current crop
> > > to defaults.
> >
> > Oh, does it mean all registers are reset to their defaults? That'd be not
> > good - no v4l(2) ioctl, AFAIK, should affect parameters, not directly
> > related to it. Even closing and reopening the video device node shouldn't
> > reset values. So, maybe you should drop that reset completely.
> 
> Shouldn't I rather move it over into the ov6650_video_probe()?

Good idea!:)

> ...
> > > > 2. in your s_fmt you accept only two output sizes: CIF or QCIF, that's
> > > > ok, if that's all you can configure with your driver.
> > >
> > > Not any longer :). I'm able to configure using current crop geometry
> > > only, either unscaled or scaled down by 2. I'm not able to configure
> > > neither exact CIF nor QCIF if my current crop window doesn't match,
> > > unless I'm allowed to change the crop from here.
> >
> > Hm, but in your s_fmt you do:
> >
> > +	switch (mf->width) {
> > +	case W_QCIF:
> > +		dev_dbg(&client->dev, "resolution QCIF\n");
> > +		priv->qcif = 1;
> > +		coma_set |= COMA_QCIF;
> > +		priv->pclk_max /= 2;
> > +		break;
> > +	case W_CIF:
> > +		dev_dbg(&client->dev, "resolution CIF\n");
> > +		priv->qcif = 0;
> > +		coma_mask |= COMA_QCIF;
> > +		break;
> > +	default:
> > +		dev_err(&client->dev, "unspported resolution!\n");
> > +		return -EINVAL;
> > +	}
> >
> > So, you accept only CIF or QCIF as your output window. Or do you mean a v3
> > by your "not any longer?" 
> 
> Exactly!
> 
> > And yes, you are allowed to change your input 
> > sensor window, if that lets you configure your output format more
> > precisely. And v.v. The rule is - the most recent command wins.
> 
> I see.
> 
> ...
> > No, there's nothing wrong with your sensor:) So, what I would do is:
> >
> > 1. in your struct ov6650:
> >
> > +	struct v4l2_rect	rect;		/* sensor cropping window */
> > +	bool			half_scale;	/* scale down output by 2 */
> >
> > 2. in s_crop verify left, width, top, height, program them into the chip
> > and store in ->rect
> >
> > 3. in g_crop just return values from ->rect
> >
> > 4. in s_fmt you have to select an input rectangle, that would allow you to
> > possibly exactly configure the requested output format. Say, if you have a
> > 320x240 cropping configured and you get an s_fmt request for 120x90. You
> > can either set your input rectangle to 240x180 and scale it down by 2, or
> > set the rectangle directly to 120x90. Obviously, it's better to use
> > 240x180 and scale down, because that's closer to the current cropping of
> > 320x240. So, in s_fmt you select a new input rectangle _closest_ to the
> > currently configured one, that would allow you to configure the correct
> > output format. Then you set your ->rect with the new values and your
> > ->half_scale
> >
> > 5. in g_fmt you return ->rect scaled with ->half_scale
> >
> > Makes sense?
> 
> Absolutely. Hope to submit v3 soon.

Good! Looking forward:)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
