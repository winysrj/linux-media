Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58830 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaHVDTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 23:19:11 -0400
Received: by mail-pa0-f42.google.com with SMTP id lf10so15933477pab.29
        for <linux-media@vger.kernel.org>; Thu, 21 Aug 2014 20:19:10 -0700 (PDT)
Date: Fri, 22 Aug 2014 11:19:11 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <1408667621-12072-1-git-send-email-crope@iki.fi>
Subject: Re: [PATCH 6/6] m88ds3103: change .set_voltage() implementation
Message-ID: <201408221119057340205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


It is easier to understand for using "voltage_dis" to keep the same logic for voltage selection and off/on.

>Add some error checking and implement functionality a little bit
>differently.
>
>Signed-off-by: Antti Palosaari <crope@iki.fi>
>---
> drivers/media/dvb-frontends/m88ds3103.c | 50 ++++++++++++++++++++++-----------
> 1 file changed, 34 insertions(+), 16 deletions(-)
>
>diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
>index 238b04e..d8fbdfd 100644
>--- a/drivers/media/dvb-frontends/m88ds3103.c
>+++ b/drivers/media/dvb-frontends/m88ds3103.c
>@@ -1038,36 +1038,54 @@ err:
> }
> 
> static int m88ds3103_set_voltage(struct dvb_frontend *fe,
>-	fe_sec_voltage_t voltage)
>+	fe_sec_voltage_t fe_sec_voltage)
> {
> 	struct m88ds3103_priv *priv = fe->demodulator_priv;
>-	u8 data;
>+	int ret;
>+	u8 u8tmp;
>+	bool voltage_sel, voltage_en;
bool voltage_sel, voltage_dis;
> 
>-	m88ds3103_rd_reg(priv, 0xa2, &data);
>+	dev_dbg(&priv->i2c->dev, "%s: fe_sec_voltage=%d\n", __func__,
>+			fe_sec_voltage);
> 
>-	data &= ~0x03; /* bit0 V/H, bit1 off/on */
>-	if (priv->cfg->lnb_en_pol)
>-		data |= 0x02;
>+	if (!priv->warm) {
>+		ret = -EAGAIN;
>+		goto err;
>+	}
> 
>-	switch (voltage) {
>+	switch (fe_sec_voltage) {
> 	case SEC_VOLTAGE_18:
>-		if (priv->cfg->lnb_hv_pol == 0)
>-			data |= 0x01;
>+		voltage_sel = 1;
>+		voltage_en = 1;
voltage_dis = 0;
> 		break;
> 	case SEC_VOLTAGE_13:
>-		if (priv->cfg->lnb_hv_pol)
>-			data |= 0x01;
>+		voltage_sel = 0;
>+		voltage_en = 1;
voltage_dis = 0;
> 		break;
> 	case SEC_VOLTAGE_OFF:
>-		if (priv->cfg->lnb_en_pol)
>-			data &= ~0x02;
>-		else
>-			data |= 0x02;
>+		voltage_sel = 0;
>+		voltage_en = 0;
voltage_dis = 1;
> 		break;
>+	default:
>+		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_voltage\n",
>+				__func__);
>+		ret = -EINVAL;
>+		goto err;
> 	}
>-	m88ds3103_wr_reg(priv, 0xa2, data);
>+
>+	/* output pin polarity */
>+	voltage_sel ^= priv->cfg->lnb_hv_pol;
>+	voltage_en ^= !priv->cfg->lnb_en_pol;
voltage_dis ^= priv->cfg->lnb_en_pol;
>+
>+	u8tmp = voltage_en << 1 | voltage_sel << 0;
u8tmp = voltage_dis << 1 | voltage_sel << 0;
>+	ret = m88ds3103_wr_reg_mask(priv, 0xa2, u8tmp, 0x03);
>+	if (ret)
>+		goto err;
> 
> 	return 0;
>+err:
>+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
>+	return ret;
> }
> 
> static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
>-- 
>http://palosaari.fi/
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

