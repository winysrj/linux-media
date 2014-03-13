Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:16035 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaCMQlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 12:41:00 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2D006KLVOBRE90@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Mar 2014 12:40:59 -0400 (EDT)
Date: Thu, 13 Mar 2014 13:40:54 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [REVIEW PATCH 02/16] e4000: implement controls via v4l2 control
 framework
Message-id: <20140313134054.63122089@samsung.com>
In-reply-to: <5321CC1E.3080509@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
 <1393461025-11857-3-git-send-email-crope@iki.fi>
 <20140313105727.43c3d689@samsung.com> <5321CC1E.3080509@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Mar 2014 17:17:50 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 13.03.2014 15:57, Mauro Carvalho Chehab wrote:
> > Em Thu, 27 Feb 2014 02:30:11 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> Implement gain and bandwidth controls using v4l2 control framework.
> >> Pointer to control handler is provided by exported symbol.
> >>
> >> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> >> Signed-off-by: Antti Palosaari <crope@iki.fi>
> >> ---
> >>   drivers/media/tuners/e4000.c      | 210 +++++++++++++++++++++++++++++++++++++-
> >>   drivers/media/tuners/e4000.h      |  14 +++
> >>   drivers/media/tuners/e4000_priv.h |  75 ++++++++++++++
> >>   3 files changed, 298 insertions(+), 1 deletion(-)
> >
> > ...
> >> diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
> >> index e74b8b2..989f2ea 100644
> >> --- a/drivers/media/tuners/e4000.h
> >> +++ b/drivers/media/tuners/e4000.h
> >> @@ -40,4 +40,18 @@ struct e4000_config {
> >>   	u32 clock;
> >>   };
> >>
> >> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
> >> +extern struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
> >> +		struct dvb_frontend *fe
> >> +);
> >> +#else
> >> +static inline struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
> >> +		struct dvb_frontend *fe
> >> +)
> >> +{
> >> +	pr_warn("%s: driver disabled by Kconfig\n", __func__);
> >> +	return NULL;
> >> +}
> >> +#endif
> >> +
> >>   #endif
> >
> > There are two things to be noticed here:
> >
> > 1) Please don't add any EXPORT_SYMBOL() on a pure I2C module. You
> > should, instead, use the subdev calls, in order to callback a
> > function provided by the module;
> 
> That means, I have to implement it as a V4L subdev driver then...

Yes, or to create some other type of binding. IMO, we should move
the subdev interface one level up, as we'll need to use it also
for some other DVB drivers, with a different set of callbacks.

> Is there any problem to leave as it is? It just only provides control 
> handler using that export. If you look those existing dvb frontend or 
> tuner drivers there is many kind of resources exported just similarly 
> (example DibCom PID filters, af9033 pid filters), so I cannot see why 
> that should be different.

Well, try googling for:
	undefined reference to `dib3000mc_get_tuner_i2c_master'

And you'll see that having more than one export on a DVB frontend
driver doesn't work.

If you want to see what happens, try to compile rtl28xxu builtin
and e4000 as a module.

What happens is that dvb_attach() will request the tuner module, 
if the driver provides just the foo_attach. 

If you see what dvb_attach() does, it is actually a kind of
"request_module" that uses a symbol name instead of the module
name, plus a dynamically solved call to the attach function. 
It also increments the loaded module kref (but without assigning
the module caller ownership).

So, it is actually a dirty hack.

In your case, rtl28xxu builtin will have a hard reference for
e4000_get_ctrl_handler, with will cause a compilation breakage
if e4000 is compiled as module.

What the previous I2C model did, and v4l2 subdev does, is to provide
a way for the driver to register a set of callbacks. This way,
all that the caller driver needs to do is to check if the callback
is set. If so, calls it.

> 
> > 2) As you're now using request_module(), you don't need to use
> > #if IS_ENABLED() anymore. It is up to the module to register
> > itself as a V4L2 subdevice. The caller module should use the
> > subdevice interface to run the callbacks.
> >
> > If you don't to that, you'll have several issues with the
> > building system.
> 
> So basically you are saying I should implement that driver as a V4L 
> subdev too?

Basically, I'm saying that your patch will break compilation, and,
at a first glance, the subdev approach is the better way to solve it.
> 
> regards
> Antti
> 


-- 

Regards,
Mauro
