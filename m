Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46946 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbbLUCmR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 21:42:17 -0500
Subject: Re: [PATCH 1/3] rtl2832: add support for slave ts pid filter
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
References: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56776708.4010204@iki.fi>
Date: Mon, 21 Dec 2015 04:42:16 +0200
MIME-Version: 1.0
In-Reply-To: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch looks acceptable, but it is broken in a mean it does not apply :(

$ wget -O - https://patchwork.linuxtv.org/patch/32030/mbox/ | git am -3 -s
--2015-12-21 04:40:46--  https://patchwork.linuxtv.org/patch/32030/mbox/
Resolving patchwork.linuxtv.org (patchwork.linuxtv.org)... 130.149.80.248
Connecting to patchwork.linuxtv.org 
(patchwork.linuxtv.org)|130.149.80.248|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/plain]
Saving to: ‘STDOUT’

-                                                   [ <=> 
 
               ]   2.73K  --.-KB/s   in 0s

2015-12-21 04:40:46 (60.4 MB/s) - written to stdout [2796]

Applying: rtl2832: add support for slave ts pid filter
fatal: corrupt patch at line 39
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 rtl2832: add support for slave ts pid filter
The copy of the patch that failed is found in:
    /home/crope/linuxtv/code/media_tree/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
[crope@localhost media_tree]$ patch -p1 < .git/rebase-apply/patch
patching file drivers/media/dvb-frontends/rtl2832.c
patch: **** malformed patch at line 39: @@ -1178,14 +1185,22 @@ static 
int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,

[crope@localhost media_tree]$ git am --abort
[crope@localhost media_tree]$ git am ~/\[PATCH\ 1_3\]\ rtl2832\:\ add\ 
support\ for\ slave\ ts\ pid\ filter.eml
Applying: rtl2832: add support for slave ts pid filter
fatal: corrupt patch at line 39
Patch failed at 0001 rtl2832: add support for slave ts pid filter
The copy of the patch that failed is found in:
    /home/crope/linuxtv/code/media_tree/.git/rebase-apply/patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
[crope@localhost media_tree]$ git am --abort

Antti

On 11/29/2015 04:10 AM, Benjamin Larsson wrote:
> Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
> ---
>   drivers/media/dvb-frontends/rtl2832.c      | 21 ++++++++++++++++++---
>   drivers/media/dvb-frontends/rtl2832_priv.h |  1 +
>   2 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index 78b87b2..e054079 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -407,6 +407,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
>   	/* start statistics polling */
>   	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
>   	dev->sleeping = false;
> +	dev->slave_ts = false;
>
>   	return 0;
>   err:
> @@ -1122,6 +1123,8 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
>   	if (ret)
>   		goto err;
>
> +	dev->slave_ts = true;
> +
>   	return 0;
>   err:
>   	dev_dbg(&client->dev, "failed=%d\n", ret);
> @@ -1143,7 +1146,11 @@ static int rtl2832_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
>   	else
>   		u8tmp = 0x00;
>
> -	ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
> +	if (dev->slave_ts)
> +		ret = rtl2832_update_bits(client, 0x021, 0xc0, u8tmp);
> +	else
> +		ret = rtl2832_update_bits(client, 0x061, 0xc0, u8tmp);
>   	if (ret)
>   		goto err;
>
> @@ -1178,14 +1185,22 @@ static int rtl2832_pid_filter(struct dvb_frontend *fe, u8 index, u16 pid,
>   	buf[1] = (dev->filters >>  8) & 0xff;
>   	buf[2] = (dev->filters >> 16) & 0xff;
>   	buf[3] = (dev->filters >> 24) & 0xff;
> -	ret = rtl2832_bulk_write(client, 0x062, buf, 4);
> +
> +	if (dev->slave_ts)
> +		ret = rtl2832_bulk_write(client, 0x022, buf, 4);
> +	else
> +		ret = rtl2832_bulk_write(client, 0x062, buf, 4);
>   	if (ret)
>   		goto err;
>
>   	/* add PID */
>   	buf[0] = (pid >> 8) & 0xff;
>   	buf[1] = (pid >> 0) & 0xff;
> -	ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
> +
> +	if (dev->slave_ts)
> +		ret = rtl2832_bulk_write(client, 0x026 + 2 * index, buf, 2);
> +	else
> +		ret = rtl2832_bulk_write(client, 0x066 + 2 * index, buf, 2);
>   	if (ret)
>   		goto err;
>
> diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
> index 5dcd3a4..efc230f 100644
> --- a/drivers/media/dvb-frontends/rtl2832_priv.h
> +++ b/drivers/media/dvb-frontends/rtl2832_priv.h
> @@ -46,6 +46,7 @@ struct rtl2832_dev {
>   	bool sleeping;
>   	struct delayed_work i2c_gate_work;
>   	unsigned long filters; /* PID filter */
> +	bool slave_ts;
>   };
>
>   struct rtl2832_reg_entry {
>

-- 
http://palosaari.fi/
