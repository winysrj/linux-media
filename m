Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab1FAN5V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 09:57:21 -0400
Message-ID: <4DE64531.2050301@redhat.com>
Date: Wed, 01 Jun 2011 10:57:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: abraham.manu@gmail.com
CC: Florent AUDEBERT <florent.audebert@anevia.com>,
	linux-media@vger.kernel.org,
	Florent Audebert <faudebert@anevia.com>
Subject: Re: [PATCH] stb0899: Removed an extra byte sent at init on DiSEqC
 bus
References: <4C125DD5.6060604@anevia.com> <4CBD9543.2050107@anevia.com> <4CBDC1CC.6030704@gmail.com>
In-Reply-To: <4CBDC1CC.6030704@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 14:05, Mauro Carvalho Chehab escreveu:
> Em 19-10-2010 10:55, Florent AUDEBERT escreveu:
>> On 06/11/2010 06:01 PM, Florent AUDEBERT wrote:
>>> I noticed a stray 0x00 at init on DiSEqC bus (KNC1 DVB-S2) with a DiSEqC
>>> tool analyzer.
>>>
>>> I removed the register from initialization table and all seem to go well
>>> (at least for my KNC board).
>>
>> Hi,
>>
>> This old small patch had been marked superseded on patchwork[1].
>>
>> Is there an non-obvious case when patches go superseded ? Perhaps I missed
>> something but it seems to me no other patch replaced it.
> 
> This is one of the bad things with patchwork: there's no "reason" field associated
> to a status change, nor it marks when the status were changed.
> 
> A search on my linux-media box, showed that this patch were there, waiting for
> Manu review, at the email I sent on Jul, 6 2010. The patch still applies, and
> I didn't find any reply from Manu giving any feedback about it.
> 
> So, I'm re-tagging it as under review.
> 
> Manu, any comments about this patch (and the other remaining patches that we're
> waiting fro your review) ?

Manu,

Please ack or nack this patch. It was sent about 1,5 years ago! if you don't
comment, I'll assume that this patch is ok and I'll apply it.

Thanks,
Mauro.


Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: stb0899: Removed an extra byte sent at init on DiSEqC bus
Date: Fri, 11 Jun 2010 16:01:25 -0000
From: Florent AUDEBERT <florent.audebert@anevia.com>
X-Patchwork-Id: 105621
Message-Id: <4C125DD5.6060604@anevia.com>
To: linux-media@vger.kernel.org
Cc: abraham.manu@gmail.com, Florent Audebert <faudebert@anevia.com>


diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 6681ac1..9710e7b 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -40,7 +40,6 @@ static const struct stb0899_s1_reg az6027_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0     	, 0x04 },
 	{ STB0899_DISRX_ST1     	, 0x00 },
 	{ STB0899_DISPARITY     	, 0x00 },
-	{ STB0899_DISFIFO       	, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22        	, 0x99 },
 	{ STB0899_DISF22RX      	, 0xa8 },
diff --git a/drivers/media/dvb/mantis/mantis_vp1041.c b/drivers/media/dvb/mantis/mantis_vp1041.c
index d1aa2bc..7bb1f28 100644
--- a/drivers/media/dvb/mantis/mantis_vp1041.c
+++ b/drivers/media/dvb/mantis/mantis_vp1041.c
@@ -51,7 +51,6 @@ static const struct stb0899_s1_reg vp1041_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0     	, 0x04 },
 	{ STB0899_DISRX_ST1     	, 0x00 },
 	{ STB0899_DISPARITY     	, 0x00 },
-	{ STB0899_DISFIFO       	, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22        	, 0x99 },
 	{ STB0899_DISF22RX      	, 0xa8 },
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index 983672a..b697af4 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -896,7 +896,6 @@ static const struct stb0899_s1_reg knc1_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0		, 0x04 },
 	{ STB0899_DISRX_ST1		, 0x00 },
 	{ STB0899_DISPARITY		, 0x00 },
-	{ STB0899_DISFIFO		, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22		, 0x8c },
 	{ STB0899_DISF22RX		, 0x9a },
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 13ac9e3..da5a72c 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -1046,7 +1046,6 @@ static const struct stb0899_s1_reg tt3200_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0     	, 0x04 },
 	{ STB0899_DISRX_ST1     	, 0x00 },
 	{ STB0899_DISPARITY     	, 0x00 },
-	{ STB0899_DISFIFO       	, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22        	, 0x8c },
 	{ STB0899_DISF22RX      	, 0x9a },

