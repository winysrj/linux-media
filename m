Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:38587 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbbCUKSP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 06:18:15 -0400
Message-ID: <550D455F.4050500@southpole.se>
Date: Sat, 21 Mar 2015 11:18:07 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] mn88473: implement lock for all delivery systems
References: <1426714629-15640-1-git-send-email-benjamin@southpole.se> <550AE0CC.5050407@iki.fi> <550CA9B4.4050903@southpole.se> <550CAC52.50700@iki.fi>
In-Reply-To: <550CAC52.50700@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------030908080008080202090605"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030908080008080202090605
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/21/2015 12:25 AM, Antti Palosaari wrote:
> On 03/21/2015 01:13 AM, Benjamin Larsson wrote:
>> On 03/19/2015 03:44 PM, Antti Palosaari wrote:
>>> Bad news. It does lock for DVB-C now, but DVB-T nor DVB-T2 does not
>>> lock.
>>>
>>> regards
>>> Antti
>>
>> I'm getting tired :/. Had the time to test now and the checks is
>> supposed to be negated.
>>
>> if (utmp & 0xA0) { -> if (!(utmp & 0xA0))
>>
>> But as stock dvbv5-scan crashes on ubuntu 14.04 and I can't unload the
>> mn88473 module I will confirm this when I have an actual working version
>> of dvbv5-scan and Ubuntu.
>
> You could also use w_scan. Or install latest dvbv5-scan from git - it
> works even without install by running from compile directory.

Ok, will try that later.

Anyway, I tried the attached patch and I was able to get a lock after a 
reboot from windows with the windows driver initializing the stick. If I 
replugged the stick I get no signal and if I try the rtl2832 demod it 
reports the same. So I think that my signal is just to weak for the 
kernel r820t driver. So it would be nice if you could test this patch 
and see if it works.


>
> regards
> Antti
>

MvH
Benjamin Larsson

--------------030908080008080202090605
Content-Type: text/x-patch;
 name="0001-mn88473-implement-lock-for-all-delivery-systems.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mn88473-implement-lock-for-all-delivery-systems.patch"

>From 603398bf07ef5eccca4d632b9ef61ccf0e6b46d0 Mon Sep 17 00:00:00 2001
From: Benjamin Larsson <benjamin@southpole.se>
Date: Sun, 15 Mar 2015 23:43:07 +0100
Subject: [PATCH 1/1] mn88473: implement lock for all delivery systems
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88473/mn88473.c | 50 +++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index a23e59e..a4ff299 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -167,7 +167,10 @@ static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
+	unsigned int utmp;
+	int lock = 0;
 
 	*status = 0;
 
@@ -176,8 +179,51 @@ static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
-			FE_HAS_SYNC | FE_HAS_LOCK;
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		ret = regmap_read(dev->regmap[0], 0x62, &utmp);
+		if (ret)
+			goto err;
+		if (!(utmp & 0xA0)) {
+			if ((utmp & 0xF) >= 0x03)
+				*status |= FE_HAS_SIGNAL;
+			if ((utmp & 0xF) >= 0x09)
+				lock = 1;
+		}
+		break;
+	case SYS_DVBT2:
+		ret = regmap_read(dev->regmap[2], 0x8B, &utmp);
+		if (ret)
+			goto err;
+		if (!(utmp & 0x40)) {
+			if ((utmp & 0xF) >= 0x07)
+				*status |= FE_HAS_SIGNAL;
+			if ((utmp & 0xF) >= 0x0a)
+				*status |= FE_HAS_CARRIER;
+			if ((utmp & 0xF) >= 0x0d)
+				*status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_read(dev->regmap[1], 0x85, &utmp);
+		if (ret)
+			goto err;
+		if (!(utmp & 0x40)) {
+			ret = regmap_read(dev->regmap[1], 0x89, &utmp);
+			if (ret)
+				goto err;
+			if (utmp & 0x01)
+				lock = 1;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (lock)
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
+				FE_HAS_SYNC | FE_HAS_LOCK;
 
 	return 0;
 err:
-- 
2.1.0


--------------030908080008080202090605--
