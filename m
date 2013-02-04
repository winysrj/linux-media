Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab3BDNcc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Feb 2013 08:32:32 -0500
Date: Mon, 4 Feb 2013 11:32:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Simon Que <sque@chromium.org>, linux-media@vger.kernel.org,
	msb@chromium.org, posciak@chromium.org
Subject: Re: [PATCH] media: config option for building tuners
Message-ID: <20130204113219.484df396@redhat.com>
In-Reply-To: <CAOcJUbxG5NYFuMJ23XMwMo-FY3PUnxRGJTaDYy6O_nQec3+o0g@mail.gmail.com>
References: <1359065516-8222-1-git-send-email-sque@chromium.org>
	<CAOcJUbxG5NYFuMJ23XMwMo-FY3PUnxRGJTaDYy6O_nQec3+o0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Feb 2013 20:15:53 -0500
Michael Krufky <mkrufky@linuxtv.org> escreveu:

> On Thu, Jan 24, 2013 at 5:11 PM, Simon Que <sque@chromium.org> wrote:
> > This patch provides a Kconfig option, MEDIA_TUNER_SUPPORT, that
> > determines whether media/tuners is included in the build.  This way,
> > the tuners don't have to be unconditionally included in the build.
> >
> > Signed-off-by: Simon Que <sque@chromium.org>
> > ---
> >  drivers/media/Kconfig  | 9 +++++++++
> >  drivers/media/Makefile | 3 ++-
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 4ef0d80..a266da2 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -73,6 +73,15 @@ config MEDIA_RC_SUPPORT
> >
> >           Say Y when you have a TV or an IR device.
> >
> > +config MEDIA_TUNER_SUPPORT
> > +       tristate
> > +       help
> > +         This enables the tuner modules in the tuners directory.  Use this
> > +         option to turn on tuners.  The individual tuner modules can then be
> > +         turned on/off one-by-one.
> > +
> > +         Say Y when you have a V4L/DVB tuner in your system.
> > +
> >  #
> >  # Media controller
> >  #      Selectable only for webcam/grabbers, as other drivers don't use it
> > diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> > index 620f275..679db94 100644
> > --- a/drivers/media/Makefile
> > +++ b/drivers/media/Makefile
> > @@ -8,7 +8,8 @@ media-objs      := media-device.o media-devnode.o media-entity.o
> >  # I2C drivers should come before other drivers, otherwise they'll fail
> >  # when compiled as builtin drivers
> >  #
> > -obj-y += i2c/ tuners/
> > +obj-y += i2c/
> > +obj-$(CONFIG_MEDIA_TUNER_SUPPORT)  += tuners/
> >  obj-$(CONFIG_DVB_CORE)  += dvb-frontends/
> >
> >  #
> 
> 
> I don't quite see the benefit of this patch.  Could you explain to us
> what the desired effect is that you're looking to achieve?  I believe
> that if you have no drivers selected that need tuners, that no tuner
> drivers will be built, or at least that's how it used to work.
> 
> Even if you did select a driver that uses a tuner, you can enable the
> customization options and deselect all of the tuners drivers.  I don't
> think this patch is needed at all, if I understand your goal
> correctly.
> 
> If I'm missing something, please elaborate.

I'd say that this patch is likely broken, as it doesn't take
MEDIA_SUBDRV_AUTOSELECT Kconfig option into account.

Regards,
Mauro
