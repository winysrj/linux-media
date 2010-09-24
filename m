Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:52403 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751849Ab0IXGwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 02:52:32 -0400
Date: Fri, 24 Sep 2010 08:52:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 3/6] SoC Camera: add driver for OV6650 sensor
In-Reply-To: <201009240045.24669.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1009240811280.14966@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009222023.13696.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009231549340.23561@axis700.grange>
 <201009240045.24669.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 24 Sep 2010, Janusz Krzysztofik wrote:

> Thursday 23 September 2010 18:06:15 Guennadi Liakhovetski napisał(a):
> > On Wed, 22 Sep 2010, Janusz Krzysztofik wrote:
> > > Wednesday 22 September 2010 11:12:46 Guennadi Liakhovetski napisaÅ(a):
> > > >
> > > > On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> > > > > +	priv->rect.left	  = DEF_HSTRT << !priv->qcif;
> > > > > +	priv->rect.top	  = DEF_VSTRT << !priv->qcif;
> > > > > +	priv->rect.width  = mf->width;
> > > > > +	priv->rect.height = mf->height;
> > > >
> > > > Sorry, don't understand. The sensor can do both - cropping per HSTRT,
> > > > HSTOP, VSTRT and VSTOP and scaling per COMA_CIF / COMA_QCIF, right?
> > >
> > > Right.
> > >
> > > > But
> > > > which of them is stored in your priv->rect? Is this the input window
> > > > (cropping) or the output one (scaling)?
> > >
> > > I'm not sure how I can follow your input/output concept here.
> > > Default (reset) values of HSTRT, HSTOP, VSTRT and VSTOP registers are the
> > > same for both CIF and QCIF, giving a 176x144 picture area in both cases.
> > > Than, when in CIF (reset default) mode, which actual size is double of
> > > that (352x288), I scale them by 2 when converting to priv->rect elements.
> > >
> > > > You overwrite it in .s_fmt and
> > > > .s_crop...
> > >
> > > I added the priv->rect to be returned by g_crop() instead of
> > > recalculating it from the register values. Then, I think I have to
> > > overwrite it on every geometry change, whether s_crop or s_fmt caused. Am
> > > I missing something?
> >
> > If I understand your sensor correctly, HSTRT etc. registers configure
> > pretty much any (input) sensor window, 
> 
> Let's say, not exceeding CIF geometry (352x288).

Yes, sorry, forgot to mention that.

> > whereas COMA and COML select 
> > whether to scale it to a CIF or to a QCIF output. 
> 
> I think the answer is: not exactly. AFAICT, the COMA_QCIF bit selects whether 
> to scale it down by 2 (QCIF selection) or not (CIF selection).

Ah! Ok, that it would be better to select different names for those bits.

> > So, these are two 
> > different things. Hence your ->rect can hold only one of the two - the
> > sensor window or the output image. Since output image has only two options
> > - CIF or QCIF, you don't need to store it in rect, you already have
> > priv->qcif.
> 
> With the above reservation - yes, I could use priv->qcif to scale priv->rect 
> down by 2 or not in g_fmt.

...and for the ->qcif member.

> > Oh, and one more thing - didn't notice before: in your cropcap you do
> >
> > +	int shift = !priv->qcif;
> > ...
> > +	a->bounds.left			= DEF_HSTRT << shift;
> > +	a->bounds.top			= DEF_VSTRT << shift;
> > +	a->bounds.width			= W_QCIF << shift;
> > +	a->bounds.height		= H_QCIF << shift;
> >
> > Don't think this is right. cropcap shouldn't depend on any dynamic
> > (configured by S_FMT) setting, it contains absolute limits of your
> > hardware. I know I might have produced a couple of bad examples in the
> > past - before I eventually settled with this definition... So, I think,
> > it's best to put the full sensor resolution in cropcap.
> 
> OK.
> 
> > ...and, please, replace
> >
> > +		priv->qcif = 1;
> > with
> > +		priv->qcif = true;
> > and
> > +		priv->qcif = 0;
> > with
> > +		priv->qcif = false;
> > in ov6650_s_fmt().
> 
> Sure.
> 
> > But I think your driver might have a problem with its cropping / scaling
> > handling. Let's see if I understand it right:
> >
> > 1. as cropcap you currently return QCIF or CIF, depending on the last
> > S_FMT, 
> 
> Yes.
> 
> BTW, my S_FMT always calls ov6650_reset(), which resets the current crop to 
> defaults.

Oh, does it mean all registers are reset to their defaults? That'd be not 
good - no v4l(2) ioctl, AFAIK, should affect parameters, not directly 
related to it. Even closing and reopening the video device node shouldn't 
reset values. So, maybe you should drop that reset completely.

> This behaviour doesn't follow the requirement of this operation 
> being done only once, when the driver is first loaded, but not later. Should 
> I restore the last crop after every reset? If yes, what is the purpose of 
> defrect if applied only at driver first load?

that's exactly the purpose, I think.

> > but let's say, you fix it to always return CIF. 
> 
> OK.
> 
> > 2. in your s_fmt you accept only two output sizes: CIF or QCIF, that's ok,
> > if that's all you can configure with your driver.
> 
> Not any longer :). I'm able to configure using current crop geometry only, 
> either unscaled or scaled down by 2. I'm not able to configure neither exact 
> CIF nor QCIF if my current crop window doesn't match, unless I'm allowed to 
> change the crop from here.

Hm, but in your s_fmt you do:

+	switch (mf->width) {
+	case W_QCIF:
+		dev_dbg(&client->dev, "resolution QCIF\n");
+		priv->qcif = 1;
+		coma_set |= COMA_QCIF;
+		priv->pclk_max /= 2;
+		break;
+	case W_CIF:
+		dev_dbg(&client->dev, "resolution CIF\n");
+		priv->qcif = 0;
+		coma_mask |= COMA_QCIF;
+		break;
+	default:
+		dev_err(&client->dev, "unspported resolution!\n");
+		return -EINVAL;
+	}

So, you accept only CIF or QCIF as your output window. Or do you mean a v3 
by your "not any longer?" And yes, you are allowed to change your input 
sensor window, if that lets you configure your output format more 
precisely. And v.v. The rule is - the most recent command wins.

> > 3. in s_crop you accept anything with left + width <= HSTOP and top +
> > height <= VSTOP. This I don't understand. Your HSTOP and VSTOP are fixed
> > values, based on QCIF plus some offsets. So, you would accept widths up to
> > "a little larger than QCIF width" and similar heights. 
> 
> Do you mean I should also verify if (rect->left >= DEF_HSTRT) and (rect->top 
> >= DEF_VSTRT)? I should probably.

Yes, if you cannot handle smaller values.

> > Then, without 
> > changing COMA and COML you assume, that the output size changed equally,
> > because that's what you return in g_fmt.
> 
> I think I've verified, to the extent possible using v4l2-dbg, that it works 
> like this. If I change the input height by overwriting VSTOP with a slightly 
> higher value, the output seems to change proportionally and starts rolling 
> down, since the host is not updated to handle the so changed frame size.

Yes, now that I know, that that flag is actually a scale-down-by-2 switch.

> > Anyway, I think, there is some misunderstanding of the v4l2 cropping and
> > scaling procedures. Please, have a look here:
> > http://v4l2spec.bytesex.org/spec/x1904.htm. Do you agree, that what your
> > driver is implementing doesn't reflect that correctly?;)
> 
> Yes, I do. And I think that that the reason of this misunderstanding is my 
> sensor just not matching the v4l2 model with its limited, probably uncommon 
> scaling capability, or me still not being able to map the sensor to the v4l2 
> model correctly. What do you think?

No, there's nothing wrong with your sensor:) So, what I would do is:

1. in your struct ov6650:

+	struct v4l2_rect	rect;		/* sensor cropping window */
+	bool			half_scale;	/* scale down output by 2 */

2. in s_crop verify left, width, top, height, program them into the chip 
and store in ->rect

3. in g_crop just return values from ->rect

4. in s_fmt you have to select an input rectangle, that would allow you to 
possibly exactly configure the requested output format. Say, if you have a 
320x240 cropping configured and you get an s_fmt request for 120x90. You 
can either set your input rectangle to 240x180 and scale it down by 2, or 
set the rectangle directly to 120x90. Obviously, it's better to use 
240x180 and scale down, because that's closer to the current cropping of 
320x240. So, in s_fmt you select a new input rectangle _closest_ to the 
currently configured one, that would allow you to configure the correct 
output format. Then you set your ->rect with the new values and your 
->half_scale

5. in g_fmt you return ->rect scaled with ->half_scale

Makes sense?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
