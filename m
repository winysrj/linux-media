Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52889 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab1CVVee (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 17:34:34 -0400
Received: by wya21 with SMTP id 21so7135170wya.19
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 14:34:33 -0700 (PDT)
Subject: Re: [PATCH 1/2] v180 - DM04/QQBOX added support for BS2F7HZ0194
 versions
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4D87F005.4070602@redhat.com>
References: <1297560908.24985.5.camel@tvboxspy>
	 <4D87EAA7.2040803@redhat.com> <1300753968.15997.4.camel@localhost>
	 <4D87F005.4070602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 21:34:22 +0000
Message-ID: <1300829662.2048.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-03-21 at 21:40 -0300, Mauro Carvalho Chehab wrote:
> Em 21-03-2011 21:32, Malcolm Priestley escreveu:
> > On Mon, 2011-03-21 at 21:17 -0300, Mauro Carvalho Chehab wrote:
> >> Em 12-02-2011 23:35, Malcolm Priestley escreveu:
> >>> Old versions of these boxes have the BS2F7HZ0194 tuner module on
> >>> both the LME2510 and LME2510C.
> >>>
> >>> Firmware dvb-usb-lme2510-s0194.fw  and/or dvb-usb-lme2510c-s0194.fw
> >>> files are required.
> >>>
> >>> See Documentation/dvb/lmedm04.txt
> >>>
> >>> Patch 535181 is also required.
> >>>
> >>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> >>> ---
> >>
> >>> @@ -1110,5 +1220,5 @@ module_exit(lme2510_module_exit);
> >>>  
> >>>  MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
> >>>  MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
> >>> -MODULE_VERSION("1.76");
> >>> +MODULE_VERSION("1.80");
> >>>  MODULE_LICENSE("GPL");
> >>
> >>
> >> There were a merge conflict on this patch. The version we have was 1.75.
> >>
> >> Maybe some patch got missed?
> > 
> > 1.76 relates to remote control patches.
> > 
> > https://patchwork.kernel.org/patch/499391/
> > https://patchwork.kernel.org/patch/499401/
> 
> Ah! Ok, I'll be applying them. Btw, please, move the keycode tables to the
> proper place and use the RC core stuff. The idea is to remove all those keytables
> from kernel in a near future, and use the userspace tool to load it via udev.

For some reason patch to 1.81(552551) was also missing from the
Patchwork list earlier, although it is there now.

https://patchwork.kernel.org/patch/553551/

I will put the RC on the TODO list and hope to complete in the near
future.

Regards


Malcolm


