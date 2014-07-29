Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:49761 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaG2OGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 10:06:37 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9H0002U8J0KS70@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Jul 2014 10:06:36 -0400 (EDT)
Date: Tue, 29 Jul 2014 11:06:31 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] mceusb: select default keytable based on vendor
Message-id: <20140729110631.2443620c.m.chehab@samsung.com>
In-reply-to: <53D734F9.6060201@gentoo.org>
References: <1406494020-12840-1-git-send-email-m.chehab@samsung.com>
 <53D734F9.6060201@gentoo.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 29 Jul 2014 07:45:29 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> On 27.07.2014 22:47, Mauro Carvalho Chehab wrote:
> > Some vendors have their on keymap table that are used on
> > all (or almost all) models for that vendor.
> > 
> > So, instead of specifying the keymap table per USB ID,
> > let's use the Vendor ID's table by default.
> > 
> > At the end, this will mean less code to be added when newer
> > devices for those vendors are added.
> > 
> 
> I also did prepare something to add mceusb support, but with this only
> vendor dependant rc_map selection, it definitly is less code.
> 
> Your mceusb patches work correctly for my 930C-HD (b130) and PCTV 522e
> devices.

Thanks for testing!

Btw, do you have plans to add DVB-C support to the frontend too?
I think that this is the only big feature missing.

Regards,
Mauro
