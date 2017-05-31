Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:58711 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751019AbdEaAc0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 20:32:26 -0400
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com [209.85.218.49])
        by imap.netup.ru (Postfix) with ESMTPSA id 775358B2FB6
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 03:32:24 +0300 (MSK)
Received: by mail-oi0-f49.google.com with SMTP id b204so2041285oii.1
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 17:32:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-4-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-4-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Tue, 30 May 2017 20:32:02 -0400
Message-ID: <CAK3bHNXYyO0t2B0yhAs2Y_dn64A1K_J0D2zZ2HA-EXE==JWYVg@mail.gmail.com>
Subject: Re: [PATCH 03/19] [media] dvb-frontends/cxd2841er: immediately
 unfreeze regs when done
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>, rjkm@metzlerbros.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Abylay Ospan <aospan@netup.ru>

2017-04-09 15:38 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> Do unfreeze_regs() directly when accessing the demod registers is done,
> and don't have multiple unfreeze's on different conditions, which even
> can get prone to errors.
>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 525d006..09c25d7 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -1410,11 +1410,11 @@ static int cxd2841er_read_ber_i(struct cxd2841er_priv *priv,
>         cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x60);
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x5B, pktnum, sizeof(pktnum));
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x16, data, sizeof(data));
> +       cxd2841er_unfreeze_regs(priv);
>
>         if (!pktnum[0] && !pktnum[1]) {
>                 dev_dbg(&priv->i2c->dev,
>                                 "%s(): no valid BER data\n", __func__);
> -               cxd2841er_unfreeze_regs(priv);
>                 return -EINVAL;
>         }
>
> @@ -1424,7 +1424,6 @@ static int cxd2841er_read_ber_i(struct cxd2841er_priv *priv,
>         dev_dbg(&priv->i2c->dev, "%s(): bit_error=%u bit_count=%u\n",
>                         __func__, *bit_error, *bit_count);
>
> -       cxd2841er_unfreeze_regs(priv);
>         return 0;
>  }
>
> @@ -1634,6 +1633,8 @@ static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv,
>          * <SLV-T>    A1h       12h       [7:0]   ICPM_QUICKCNDT[7:0]
>          */
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x10, data, 3);
> +       cxd2841er_unfreeze_regs(priv);
> +
>         if (data[0] & 0x01) {
>                 value = ((u32)(data[1] & 0x1F) << 8) | (u32)(data[2] & 0xFF);
>                 min_index = 0;
> @@ -1676,11 +1677,9 @@ static u32 cxd2841er_dvbs_read_snr(struct cxd2841er_priv *priv,
>         } else {
>                 dev_dbg(&priv->i2c->dev,
>                         "%s(): no data available\n", __func__);
> -               cxd2841er_unfreeze_regs(priv);
>                 return -EINVAL;
>         }
>  done:
> -       cxd2841er_unfreeze_regs(priv);
>         *snr = res;
>         return 0;
>  }
> @@ -1709,12 +1708,12 @@ static int cxd2841er_read_snr_c(struct cxd2841er_priv *priv, u32 *snr)
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x19, data, 1);
>         qam = (enum sony_dvbc_constellation_t) (data[0] & 0x07);
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x4C, data, 2);
> +       cxd2841er_unfreeze_regs(priv);
>
>         reg = ((u32)(data[0]&0x1f) << 8) | (u32)data[1];
>         if (reg == 0) {
>                 dev_dbg(&priv->i2c->dev,
>                                 "%s(): reg value out of range\n", __func__);
> -               cxd2841er_unfreeze_regs(priv);
>                 return 0;
>         }
>
> @@ -1735,11 +1734,9 @@ static int cxd2841er_read_snr_c(struct cxd2841er_priv *priv, u32 *snr)
>                 *snr = -88 * (int32_t)sony_log(reg) + 86999;
>                 break;
>         default:
> -               cxd2841er_unfreeze_regs(priv);
>                 return -EINVAL;
>         }
>
> -       cxd2841er_unfreeze_regs(priv);
>         return 0;
>  }
>
> @@ -1758,17 +1755,17 @@ static int cxd2841er_read_snr_t(struct cxd2841er_priv *priv, u32 *snr)
>         cxd2841er_freeze_regs(priv);
>         cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x10);
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x28, data, sizeof(data));
> +       cxd2841er_unfreeze_regs(priv);
> +
>         reg = ((u32)data[0] << 8) | (u32)data[1];
>         if (reg == 0) {
>                 dev_dbg(&priv->i2c->dev,
>                         "%s(): reg value out of range\n", __func__);
> -               cxd2841er_unfreeze_regs(priv);
>                 return 0;
>         }
>         if (reg > 4996)
>                 reg = 4996;
>         *snr = 10000 * ((intlog10(reg) - intlog10(5350 - reg)) >> 24) + 28500;
> -       cxd2841er_unfreeze_regs(priv);
>         return 0;
>  }
>
> @@ -1787,18 +1784,18 @@ static int cxd2841er_read_snr_t2(struct cxd2841er_priv *priv, u32 *snr)
>         cxd2841er_freeze_regs(priv);
>         cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x20);
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x28, data, sizeof(data));
> +       cxd2841er_unfreeze_regs(priv);
> +
>         reg = ((u32)data[0] << 8) | (u32)data[1];
>         if (reg == 0) {
>                 dev_dbg(&priv->i2c->dev,
>                         "%s(): reg value out of range\n", __func__);
> -               cxd2841er_unfreeze_regs(priv);
>                 return 0;
>         }
>         if (reg > 10876)
>                 reg = 10876;
>         *snr = 10000 * ((intlog10(reg) -
>                 intlog10(12600 - reg)) >> 24) + 32000;
> -       cxd2841er_unfreeze_regs(priv);
>         return 0;
>  }
>
> @@ -1818,15 +1815,15 @@ static int cxd2841er_read_snr_i(struct cxd2841er_priv *priv, u32 *snr)
>         cxd2841er_freeze_regs(priv);
>         cxd2841er_write_reg(priv, I2C_SLVT, 0x00, 0x60);
>         cxd2841er_read_regs(priv, I2C_SLVT, 0x28, data, sizeof(data));
> +       cxd2841er_unfreeze_regs(priv);
> +
>         reg = ((u32)data[0] << 8) | (u32)data[1];
>         if (reg == 0) {
>                 dev_dbg(&priv->i2c->dev,
>                                 "%s(): reg value out of range\n", __func__);
> -               cxd2841er_unfreeze_regs(priv);
>                 return 0;
>         }
>         *snr = 10000 * (intlog10(reg) >> 24) - 9031;
> -       cxd2841er_unfreeze_regs(priv);
>         return 0;
>  }
>
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
