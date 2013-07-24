Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53040 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab3GXOG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:56 -0400
Message-ID: <51EFDF55.90500@iki.fi>
Date: Wed, 24 Jul 2013 17:06:13 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Taegert <jantaegert@gmx.net>
CC: linux-media@vger.kernel.org, thomas.mair86@googlemail.com
Subject: Re: PROBLEM: dvb-usb-rtl28xxu and Terratec Cinergy TStickRC (rev3)
 - no signal on some frequencies
References: <51E927EC.5030701@gmx.net> <51E92A78.50706@iki.fi> <51E974DB.7010609@gmx.net> <51ED9F8F.10206@iki.fi>
In-Reply-To: <51ED9F8F.10206@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------080806060403010803080704"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080806060403010803080704
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Could you test attached patch?

It enhances reception a little bit, you should be able to receive more 
weak signals.

I was able to made test setup against modulator. Modulator + attenuator 
+ attenuator + TV-stick, where I got picture using Windows driver at 
signal level -29dBm whilst on Linux -26.5dBm was needed. With that patch 
Linux driver started performing same as Windows.

regards
Antti

On 07/23/2013 12:09 AM, Antti Palosaari wrote:
> On 07/19/2013 08:18 PM, Jan Taegert wrote:
>> Hello,
>>
>> when the culprit is the e4000 driver but the old driver from
>> https://github.com/valtri/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
>>
>> worked for me, then must be somewhere there in the driver sources a
>> solution for the signal issues.
>>
>> Does it make sense to look for a particular string in the sources? I
>> don't have any clue of coding but perhaps I can be helpful in this way.
>
> Feel free to look. Those are different drivers and you cannot compare
> easily. For my experience you will need huge amount of time and much
> luck with that approach.
>
> As I said, the easiest solution is just to took sniffs and copy&paste
> generated code until it starts working.
>
> regards
> Antti
>
>>
>> There are
>> - tuner_e4000.c
>> - nim_rtl2832_e4000.c
>>
>> Thanks,
>> Jan.
>>
>>
>>
>> Am 19.07.2013 14:00, schrieb Antti Palosaari:
>>> Hello
>>> It is e4000 driver problem. Someone should take the look what there is
>>> wrong. Someone sent non-working stick for me, but I wasn't able to
>>> reproduce issue. I used modulator to generate signal with just same
>>> parameters he said non-working, but it worked for me. It looks like
>>> e4000 driver does not perform as well as it should.
>>>
>>> Maybe I should take Windows XP and Linux, use modulator to find out
>>> signal condition where Windows works but Linux not, took sniffs and
>>> compare registers... But I am busy and help is more than welcome.
>>>
>>> regards
>>> Antti
>>
>
>


-- 
http://palosaari.fi/

--------------080806060403010803080704
Content-Type: text/x-patch;
 name="0001-e4000-implement-DC-offset-correction.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-e4000-implement-DC-offset-correction.patch"

>From 152273ba5cda6634acbd55ef99f92206bb5a1ff5 Mon Sep 17 00:00:00 2001
From: Antti Palosaari <crope@iki.fi>
Date: Wed, 24 Jul 2013 08:04:12 +0300
Subject: [PATCH] e4000: implement DC offset correction

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 56 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 1b33ed3..a3a9c87 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -140,14 +140,12 @@ static int e4000_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	/*
-	 * TODO: Implement DC offset control correctly.
-	 * DC offsets has quite much effect for received signal quality in case
-	 * of direct conversion tuners (Zero-IF). Surely we will now lose few
-	 * decimals or even decibels from SNR...
-	 */
 	/* DC offset control */
-	ret = e4000_wr_reg(priv, 0x2d, 0x0c);
+	ret = e4000_wr_reg(priv, 0x2d, 0x1f);
+	if (ret < 0)
+		goto err;
+
+	ret = e4000_wr_regs(priv, 0x70, "\x01\x01", 2);
 	if (ret < 0)
 		goto err;
 
@@ -204,7 +202,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, sigma_delta;
 	unsigned int f_VCO;
-	u8 buf[5];
+	u8 buf[5], i_data[4], q_data[4];
 
 	dev_dbg(&priv->i2c->dev, "%s: delivery_system=%d frequency=%d " \
 			"bandwidth_hz=%d\n", __func__,
@@ -292,6 +290,48 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
+	/* DC offset */
+	for (i = 0; i < 4; i++) {
+		if (i == 0)
+			ret = e4000_wr_regs(priv, 0x15, "\x00\x7e\x24", 3);
+		else if (i == 1)
+			ret = e4000_wr_regs(priv, 0x15, "\x00\x7f", 2);
+		else if (i == 2)
+			ret = e4000_wr_regs(priv, 0x15, "\x01", 1);
+		else
+			ret = e4000_wr_regs(priv, 0x16, "\x7e", 1);
+
+		if (ret < 0)
+			goto err;
+
+		ret = e4000_wr_reg(priv, 0x29, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = e4000_rd_regs(priv, 0x2a, buf, 3);
+		if (ret < 0)
+			goto err;
+
+		i_data[i] = (((buf[2] >> 0) & 0x3) << 6) | (buf[0] & 0x3f);
+		q_data[i] = (((buf[2] >> 4) & 0x3) << 6) | (buf[1] & 0x3f);
+	}
+
+	buf[0] = q_data[0];
+	buf[1] = q_data[1];
+	buf[2] = q_data[3];
+	buf[3] = q_data[2];
+	ret = e4000_wr_regs(priv, 0x50, buf, 4);
+	if (ret < 0)
+		goto err;
+
+	buf[0] = i_data[0];
+	buf[1] = i_data[1];
+	buf[2] = i_data[3];
+	buf[3] = i_data[2];
+	ret = e4000_wr_regs(priv, 0x60, buf, 4);
+	if (ret < 0)
+		goto err;
+
 	/* gain control auto */
 	ret = e4000_wr_reg(priv, 0x1a, 0x17);
 	if (ret < 0)
-- 
1.7.11.7


--------------080806060403010803080704--
