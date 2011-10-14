Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab1JNN1r (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 09:27:47 -0400
Message-ID: <4E9838CF.6030702@redhat.com>
Date: Fri, 14 Oct 2011 10:27:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TGVhbmRybyBUZXJyw6lz?= <imlordlt@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: Support for Sveon STV22 (IT9137)
References: <CABb1zhvkLYTZ4zUy7jPh1AH+1XGQRdhsHM7CxK5ADMuuzKHAzg@mail.gmail.com> <CABb1zhvUMZ1bSqz1X5qCzOArKYsGG4EHthK-OrbAWRLn+q_+Sg@mail.gmail.com>
In-Reply-To: <CABb1zhvUMZ1bSqz1X5qCzOArKYsGG4EHthK-OrbAWRLn+q_+Sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-10-2011 02:09, Leandro Terrés escreveu:
> This device identifies has IdProduct 0xe411 and is a clone of KWorld
> UB499-2T T09(IT9137).
> 
> This patch simply adds support for this device.

Patch applies ok, with just one small whitespace issue. However, you
forgot to add your signed-off-by: on it. Also, it helps if you copy the
driver's maintainer (Malcolm).

Patchwork: http://patchwork.linuxtv.org/patch/8099/

WARNING: please, no space before tabs
#24: FILE: drivers/media/dvb/dvb-usb/dvb-usb-ids.h:323:
+#define USB_PID_SVEON_STV22_IT9137     ^I^I0xe411$

ERROR: Missing Signed-off-by: line(s)

total: 1 errors, 1 warnings, 29 lines checked
