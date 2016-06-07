Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.astim.si ([93.103.6.239]:54141 "EHLO mail.astim.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbcFGPbK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 11:31:10 -0400
From: "Saso Slavicic" <saso.linux@astim.si>
To: "'Mauro Carvalho Chehab'" <mchehab@osg.samsung.com>,
	"'Abylay Ospan'" <aospan@netup.ru>
Cc: "'linux-media'" <linux-media@vger.kernel.org>
References: <CAK3bHNUPOORumndTHSQyLa0OAnE1Ob4SLR=CoLZMbi5C-P4e4w@mail.gmail.com> <20160607122140.25a5c1c0@recife.lan>
In-Reply-To: <20160607122140.25a5c1c0@recife.lan>
Subject: RE: [GIT PULL] NetUP Universal DVB (revision 1.4)
Date: Tue, 7 Jun 2016 17:30:58 +0200
Message-ID: <001b01d1c0d1$97e32a40$c7a97ec0$@astim.si>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Content-Language: sl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please check the ASCOT2E issue for the NetUP card as well.

https://patchwork.linuxtv.org/patch/34451

Regards,
Saso

-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Mauro Carvalho
Chehab
Sent: Tuesday, June 07, 2016 5:22 PM
To: Abylay Ospan
Cc: linux-media
Subject: Re: [GIT PULL] NetUP Universal DVB (revision 1.4)

Em Mon, 16 May 2016 11:58:15 -0400
Abylay Ospan <aospan@netup.ru> escreveu:

> Hi Mauro,
> 
> Please pull code from my repository (details below). Repository is 
> based on linux-next. If it's better to send patch-by-patch basis 
> please let me know - i will prepare emails.
> 
> This patches adding support for our NetUP Universal DVB card revision
> 1.4 (ISDB-T added to this revision). This achieved by using new Sony 
> tuner HELENE (CXD2858ER) and new Sony demodulator ARTEMIS (CXD2854ER).
> And other fixes for our cards in this repository too.

Patches applied.

Please send a patch adding an entry for the new HELENE tuner driver at
MAINTAINERS.

Regards,
Mauro
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

