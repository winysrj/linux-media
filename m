Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47753 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0KBTJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 15:09:18 -0400
Received: by wyf28 with SMTP id 28so7029953wyf.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 12:09:17 -0700 (PDT)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Warnings from latest -git
Date: Tue, 2 Nov 2010 19:09:02 +0000
Cc: linux-media@vger.kernel.org
References: <201010300917.47372.chris2553@googlemail.com> <4CD00423.4060309@redhat.com>
In-Reply-To: <4CD00423.4060309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011021909.02175.chris2553@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Thanks for the reply, Mauro.

On Tuesday 02 November 2010, Mauro Carvalho Chehab wrote:
> Em 30-10-2010 04:17, Chris Clayton escreveu:
> > Hi,
> >
> > Please cc me on any reply as I'm not subscribed.
> >
> > Building v2.6.36-9452-g2d10d87 pulled this morning, I get:
> >
> > warning: (DVB_USB_DIB0700 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS &&
> > DVB_CORE && DVB_USB && !DVB_FE_CUSTOMISE) selects DVB_DIB8000 which has
> > unmet direct dependencies (MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS &&
> > DVB_FE_CUSTOMISE && DVB_CORE && I2C)
>
> It certainly requires further investigation. From your config file, we
> have, for dib0700:
>
> CONFIG_DVB_USB_DIB0700=m
> CONFIG_MEDIA_SUPPORT=m
> CONFIG_DVB_CAPTURE_DRIVERS=y
> CONFIG_DVB_CORE=m
> CONFIG_DVB_USB=m
> # CONFIG_DVB_FE_CUSTOMISE is not set
>
> And, for dib8000:
>
> CONFIG_MEDIA_SUPPORT=m
> CONFIG_DVB_CAPTURE_DRIVERS=y
> # CONFIG_DVB_FE_CUSTOMISE is not set
> CONFIG_DVB_CORE=m
> CONFIG_I2C=y
>
> Both dib0700 and dib8000 were marked as m:
>
> CONFIG_DVB_DIB8000=m
> CONFIG_DVB_USB_DIB0700=m
>
> So, in this specific example, it actually worked, but we need to find a fix
> for this bug.
>

I may be wrong, but I don't see why DVB_FE_CUSTOMISE is a dependency in these 
two cases. When it is not set, all the FE drivers are built. When it is set, 
the user selects, which drivers are to be built, but what I think the  select 
statements are doing is select drivers without which other selections the user 
has made make little sense. If that's correct, the DVB_FE_CUSTOMISE can simply 
be removed as dependencies.

Let me know if that makes sense and, if it does, I'll bake a patch.

I've now customised anyway, so teh warnings have gone away, but can soon revert 
that to test a fix.

Thanks
Chris

> Cheers,
> Mauro

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
