Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37376 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1CVAcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 20:32:55 -0400
Received: by wwa36 with SMTP id 36so8134736wwa.1
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2011 17:32:54 -0700 (PDT)
Subject: Re: [PATCH 1/2] v180 - DM04/QQBOX added support for BS2F7HZ0194
 versions
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4D87EAA7.2040803@redhat.com>
References: <1297560908.24985.5.camel@tvboxspy>
	 <4D87EAA7.2040803@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 00:32:48 +0000
Message-ID: <1300753968.15997.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-03-21 at 21:17 -0300, Mauro Carvalho Chehab wrote:
> Em 12-02-2011 23:35, Malcolm Priestley escreveu:
> > Old versions of these boxes have the BS2F7HZ0194 tuner module on
> > both the LME2510 and LME2510C.
> > 
> > Firmware dvb-usb-lme2510-s0194.fw  and/or dvb-usb-lme2510c-s0194.fw
> > files are required.
> > 
> > See Documentation/dvb/lmedm04.txt
> > 
> > Patch 535181 is also required.
> > 
> > Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> > ---
> 
> > @@ -1110,5 +1220,5 @@ module_exit(lme2510_module_exit);
> >  
> >  MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
> >  MODULE_DESCRIPTION("LME2510(C) DVB-S USB2.0");
> > -MODULE_VERSION("1.76");
> > +MODULE_VERSION("1.80");
> >  MODULE_LICENSE("GPL");
> 
> 
> There were a merge conflict on this patch. The version we have was 1.75.
> 
> Maybe some patch got missed?

1.76 relates to remote control patches.

https://patchwork.kernel.org/patch/499391/
https://patchwork.kernel.org/patch/499401/

Regards

Malcolm


