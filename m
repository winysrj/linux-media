Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:42547 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbaHGOhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 10:37:40 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9X00GZXXYRFG30@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Aug 2014 10:37:39 -0400 (EDT)
Date: Thu, 07 Aug 2014 11:37:35 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] au0828-input: Be sure that IR is enabled at polling
Message-id: <20140807113735.21460b96.m.chehab@samsung.com>
In-reply-to: <CAGoCfizexXY6QzMZ_7LxBFsf2h7P8SSBVQ4JwcwaYB4=E+3Wzw@mail.gmail.com>
References: <1407419190-10031-1-git-send-email-m.chehab@samsung.com>
 <CAGoCfix4h+Fh7PsPnhbn1wWh4-nsdMe-hjJ2B_Wrba8+0G59vg@mail.gmail.com>
 <20140807110442.353469bc.m.chehab@samsung.com>
 <CAGoCfizexXY6QzMZ_7LxBFsf2h7P8SSBVQ4JwcwaYB4=E+3Wzw@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 07 Aug 2014 10:14:45 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > Well, au8522_rc_set is defined as:
> >
> >         #define au8522_rc_set(ir, reg, bit) au8522_rc_andor(ir, (reg), (bit), (bit))
> 
> Ah, ok.  It's just a really poorly named macro.  Nevermind then.

Yep. calling it au8522_rc_setbits would likely be better. I tried to
stick with the same name convention as this macro:

drivers/media/usb/au0828/au0828.h:#define au0828_set(dev, reg, bit) au0828_andor(dev, (reg), (bit), (bit))

Regards,
Mauro
