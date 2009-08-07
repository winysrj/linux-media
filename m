Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbZHGQ2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 12:28:16 -0400
Date: Fri, 7 Aug 2009 13:28:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: fix: some webcams don't have audio inputs
Message-ID: <20090807132841.51372e65@caramujo.chehab.org>
In-Reply-To: <829197380908051158i52af640cn1b87bfe90c0890b8@mail.gmail.com>
References: <829197380908051158i52af640cn1b87bfe90c0890b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 5 Aug 2009 14:58:23 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Hello Mauro,
> 
> I just noticed this patch:
> 
> em28xx: fix: some webcams don't have audio inputs
> http://linuxtv.org/hg/v4l-dvb/rev/fe5eeff6644d
> 
> I have to wonder what the EM28XX_R00_CHIPCFG contained on this
> particular device, since this cause should have already been handled
> by the elseif() block on line 507:
> 
> } else if ((cfg & EM28XX_CHIPCFG_AUDIOMASK) == 0x00) {
>     /* The device doesn't have vendor audio at all */
>    dev->has_alsa_audio = 0;
>    dev->audio_mode.has_audio = 0;
>    return 0;
> }

Good point. I'll double check. I need one webcam with an integrated mic to be
sure if R00 has the proper value on webcams.

> On a related note, is there some rationale you can offer as to why you
> are committing patches directly into the v4l-dvb mainline without any
> peer review, unlike *every* other developer in the linuxtv project?  I
> know it may seem redundant to you since you are the person acting on
> the PULL requests, but it would provide an opportunity for the other
> developers to offer comments on your patches *before* they go into the
> mainline.

This were already answered on some previous msgs at the ML: hg commits mailing
lists give the opportunity for people to review what were committed at the
staging tree, since every patch is automatically mailbombed to the mailing
list. The mainline tree is my -git. It is delayed over -hg to give opportunity
for people to review the committed patches. Also, I'm not the kind of person
that use to talk to himself. Starting sending pull requests from me to myself
will probably get me a free ticket to a mental care services :-d



Cheers,
Mauro
