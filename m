Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d06.mx.aol.com ([205.188.109.203]:33220 "EHLO
	omr-d06.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab3HBDT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 23:19:27 -0400
Message-ID: <51FB250A.2080404@netscape.net>
Date: Fri, 02 Aug 2013 00:18:34 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com> <513A6968.4070803@netscape.net> <515A0D03.7040802@netscape.net> <51E44DCA.8060702@netscape.net> <20130716053030.3fda034e.mchehab@infradead.org> <51E6A20B.8020507@netscape.net> <20130718042314.2773b7c0.mchehab@infradead.org> <51F40976.8090106@netscape.net> <20130801090436.6dfa0f68@infradead.org> <51FA97F0.9010206@netscape.net> <20130801143742.27fdc712@infradead.org> <51FAA45F.5070100@netscape.net> <20130801154824.77461147@infradead.org>
In-Reply-To: <20130801154824.77461147@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

El 01/08/13 15:48, Mauro Carvalho Chehab escribió:
> This time it arrived fine, thanks!
>
> Btw, those changes at mb86a20s are required for it to work, or just alters
> somewhat the tuning?
>
> Regards,
> Mauro

Without these changes do not work.

With the original controller I get: mb86a20s: mb86a20s_read_status: val = 9, status = 0x1f
but not video, not sound. That is the reason why I tested with kernel 3.2.

Those changes I got to sniff the i2c traffic under windows.

I have all traffic from i2c until obtaining image(I did it as the more repetitive than 10 samples).
If it helps something I put on the list.

Also I use "modprobe cx23885 debug = 3", but I saw nothing significant

Thanks,

Alfredo





