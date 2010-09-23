Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:60414 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753830Ab0IWQGB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 12:06:01 -0400
Date: Thu, 23 Sep 2010 18:06:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 3/6] SoC Camera: add driver for OV6650 sensor
In-Reply-To: <201009222023.13696.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1009231549340.23561@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110325.08504.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009221006270.32562@axis700.grange>
 <201009222023.13696.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 22 Sep 2010, Janusz Krzysztofik wrote:

> Wednesday 22 September 2010 11:12:46 Guennadi Liakhovetski napisał(a):
> > Ok, just a couple more comments, all looking quite good so far, if we get
> > a new version soon enough, we still might manage it for 2.6.37
> >
> > On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> >
> > [snip]
> >
> > > +/* write a register */
> > > +static int ov6650_reg_write(struct i2c_client *client, u8 reg, u8 val)
> > > +{
> > > +	int ret;
> > > +	unsigned char data[2] = { reg, val };
> > > +	struct i2c_msg msg = {
> > > +		.addr	= client->addr,
> > > +		.flags	= 0,
> > > +		.len	= 2,
> > > +		.buf	= data,
> > > +	};
> > > +
> > > +	ret = i2c_transfer(client->adapter, &msg, 1);
> > > +	msleep_interruptible(1);
> >
> > Why do you want _interruptible here? Firstly it's just 1ms, secondly -
> > why?...
> 
> My bad. I didn't verified what a real difference between msleep() and 
> msleep_interruptible() is, only found that msleep_interruptible(1) makes 
> checkpatch.pl more happy than msleep(1), sorry.
> 
> What I can be sure is that a short delay is required here, otherwise the 
> driver doesn't work correctly. To prevent the checkpatch.pl from complying 
> against msleep(1), I think I could just replace it with msleep(20). What do 
> you think?

oh, no, don't think replacing msleep(1) with msleep(20) just to silence a 
compiler warning is a god idea...;) Well, use a udelay(1000). Or maybe 
try, whether a udelay(100) suffices too.

> > > +	priv->rect.left	  = DEF_HSTRT << !priv->qcif;
> > > +	priv->rect.top	  = DEF_VSTRT << !priv->qcif;
> > > +	priv->rect.width  = mf->width;
> > > +	priv->rect.height = mf->height;
> >
> > Sorry, don't understand. The sensor can do both - cropping per HSTRT,
> > HSTOP, VSTRT and VSTOP and scaling per COMA_CIF / COMA_QCIF, right? 
> 
> Right.
> 
> > But 
> > which of them is stored in your priv->rect? Is this the input window
> > (cropping) or the output one (scaling)? 
> 
> I'm not sure how I can follow your input/output concept here.
> Default (reset) values of HSTRT, HSTOP, VSTRT and VSTOP registers are the same 
> for both CIF and QCIF, giving a 176x144 picture area in both cases. Than, 
> when in CIF (reset default) mode, which actual size is double of that 
> (352x288), I scale them by 2 when converting to priv->rect elements.
> 
> > You overwrite it in .s_fmt and 
> > .s_crop...
> 
> I added the priv->rect to be returned by g_crop() instead of recalculating it 
> from the register values. Then, I think I have to overwrite it on every 
> geometry change, whether s_crop or s_fmt caused. Am I missing something?

If I understand your sensor correctly, HSTRT etc. registers configure 
pretty much any (input) sensor window, whereas COMA and COML select 
whether to scale it to a CIF or to a QCIF output. So, these are two 
different things. Hence your ->rect can hold only one of the two - the 
sensor window or the output image. Since output image has only two options 
- CIF or QCIF, you don't need to store it in rect, you already have 
priv->qcif.


Oh, and one more thing - didn't notice before: in your cropcap you do

+	int shift = !priv->qcif;
...
+	a->bounds.left			= DEF_HSTRT << shift;
+	a->bounds.top			= DEF_VSTRT << shift;
+	a->bounds.width			= W_QCIF << shift;
+	a->bounds.height		= H_QCIF << shift;

Don't think this is right. cropcap shouldn't depend on any dynamic 
(configured by S_FMT) setting, it contains absolute limits of your 
hardware. I know I might have produced a couple of bad examples in the 
past - before I eventually settled with this definition... So, I think, 
it's best to put the full sensor resolution in cropcap.

...and, please, replace

+		priv->qcif = 1;
with
+		priv->qcif = true;
and
+		priv->qcif = 0;
with
+		priv->qcif = false;
in ov6650_s_fmt().

But I think your driver might have a problem with its cropping / scaling 
handling. Let's see if I understand it right:

1. as cropcap you currently return QCIF or CIF, depending on the last 
S_FMT, but let's say, you fix it to always return CIF.

2. in your s_fmt you accept only two output sizes: CIF or QCIF, that's ok, 
if that's all you can configure with your driver.

3. in s_crop you accept anything with left + width <= HSTOP and top + 
height <= VSTOP. This I don't understand. Your HSTOP and VSTOP are fixed 
values, based on QCIF plus some offsets. So, you would accept widths up to 
"a little larger than QCIF width" and similar heights. Then, without 
changing COMA and COML you assume, that the output size changed equally, 
because that's what you return in g_fmt.

Anyway, I think, there is some misunderstanding of the v4l2 cropping and 
scaling procedures. Please, have a look here: 
http://v4l2spec.bytesex.org/spec/x1904.htm. Do you agree, that what your 
driver is implementing doesn't reflect that correctly?;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
