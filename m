Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58718 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0KEKiV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Nov 2010 06:38:21 -0400
Received: by wwb39 with SMTP id 39so1244472wwb.1
        for <linux-media@vger.kernel.org>; Fri, 05 Nov 2010 03:38:20 -0700 (PDT)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: linux-media@vger.kernel.org
Subject: Fwd: Re: Warnings from latest -git
Date: Fri, 5 Nov 2010 10:38:04 +0000
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011051038.04674.chris2553@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Forwarding to linux-media, which I somehow removed from the list of recipients. 
Also removing indentation from part of my message. Don't know how that 
happened.

----------  Forwarded Message  ----------

Subject: Re: Warnings from latest -git
Date: Friday 05 November 2010
From: Chris Clayton <chris2553@googlemail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>

Hi again,

>On 2 November 2010 19:09, Chris Clayton <chris2553@googlemail.com> wrote:

> >Thanks for the reply, Mauro.
>
> >On Tuesday 02 November 2010, Mauro Carvalho Chehab wrote:
> >> Em 30-10-2010 04:17, Chris Clayton escreveu:
> >> > Hi,
> >> >
> >> > Please cc me on any reply as I'm not subscribed.
> >> >
> >> > Building v2.6.36-9452-g2d10d87 pulled this morning, I get:
> >> >
> >> > warning: (DVB_USB_DIB0700 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS &&
> > > DVB_CORE && DVB_USB && !DVB_FE_CUSTOMISE) selects DVB_DIB8000 which has
> >> > unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS &&
> >> > DVB_FE_CUSTOMISE && DVB_CORE && I2C)
> >>
> >> It certainly requires further investigation. From your config file, we
> >> have, for dib0700:
> >>
> >> CONFIG_DVB_USB_DIB0700=m
> >> CONFIG_MEDIA_SUPPORT=m
> >> CONFIG_DVB_CAPTURE_DRIVERS=y
> >> CONFIG_DVB_CORE=m
> >> CONFIG_DVB_USB=m
> >> # CONFIG_DVB_FE_CUSTOMISE is not set
> >>
> >> And, for dib8000:
> >>
> >> CONFIG_MEDIA_SUPPORT=m
> >> CONFIG_DVB_CAPTURE_DRIVERS=y
> >> # CONFIG_DVB_FE_CUSTOMISE is not set
> >> CONFIG_DVB_CORE=m
> >> CONFIG_I2C=y
> >>
> >> Both dib0700 and dib8000 were marked as m:
> >>
> >> CONFIG_DVB_DIB8000=m
> >> CONFIG_DVB_USB_DIB0700=m
> >>
> >> So, in this specific example, it actually worked, but we need to find a
> fix
> >> for this bug.
> >
>
> > I may be wrong, but I don't see why DVB_FE_CUSTOMISE is a dependency in
> these
> > two cases. When it is not set, all the FE drivers are built. When it is
> set,
> > the user selects, which drivers are to be built, but what I think the
>  select
> > statements are doing is select drivers without which other selections the
> user
> > has made make little sense. If that's correct, the DVB_FE_CUSTOMISE can
> simply
> > be removed as dependencies.
>

I've  looked at and played around with the related Kconfig files.. The
"conflict" arises because when DVB_USB_DIB_0700 is selected, it triggers the
selection of DVB_DIB8000 if !DVB_FE_CUSTOMISE. However, the menu that
DVB_DIB8000 is contained in an "if DVB_FE_CUSTOMIZE" block and that seems to
make DVB_FE_CUSTOMIZE a direct dependency for DVB_DIB8000. I guess the
intention of the if block was to simply switch the display of the menu on or
off.

There are identical truth conflicts involving DVB_TUNER_CUSTOMISE.

The only way I have been able to avoid the warnings is by removing the if blocks 
that guard the frontend customisation menu, but simply doing that makes the
related question about customisation look silly.

I don't get this warning in 2.6.36, so I've checked recent changes to
kconfig and 246cf9c26bf11f2bffbecea6e5bd222eee7b1df8 looks as if it will be
the "culprit". It's not a regression, however.  It's a deliberate change to
report the type of conflict we have here. It looks like we need a different
scheme for controlling the visibility of the customisation menu. I'll look
at the kconfig docs and see if I can figure anything out.

Chris


> > Let me know if that makes sense and, if it does, I'll bake a patch.
>
> > I've now customised anyway, so teh warnings have gone away, but can soon
> revert
> > that to test a fix.
>
> > Thanks
> > Chris
>
> >> Cheers,
> >> Mauro
>
> --
> The more I see, the more I know. The more I know, the less I understand.
> Changing Man - Paul Weller
>



-- 
The more I see, the more I know. The more I know, the less I understand.
Changing Man - Paul Weller

-------------------------------------------------------

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
