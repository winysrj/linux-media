Return-path: <mchehab@pedra>
Received: from n7-vm0.bullet.mail.in.yahoo.com ([202.86.4.134]:24156 "HELO
	n7-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750875Ab0HTME0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Aug 2010 08:04:26 -0400
Message-ID: <555961.26177.qm@web95110.mail.in2.yahoo.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-3-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-4-git-send-email-matti.j.aaltonen@nokia.com> <1280758003-16118-5-git-send-email-matti.j.aaltonen@nokia.com>
Date: Fri, 20 Aug 2010 17:34:23 +0530 (IST)
From: pramodh ag <pramodhag@yahoo.co.in>
Subject: Re: [PATCH v7 4/5] V4L2: WL1273 FM Radio: Controls for the FM radio.
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
In-Reply-To: <1280758003-16118-5-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

> +static ssize_t wl1273_fm_fops_write(struct file *file, const char __user 
*buf,
> +                    size_t count, loff_t *ppos)
> +{
> +    struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
> +    u16 val;
> +    int r;
> +
> +    dev_dbg(radio->dev, "%s\n", __func__);
> +
> +    if (radio->core->mode != WL1273_MODE_TX)
> +        return count;
> +
> +    if (!radio->rds_on) {
> +        dev_warn(radio->dev, "%s: RDS not on.\n", __func__);
> +        return 0;
> +    }

Aren't you planning to use extended controls "V4L2_CID_RDS_TX_RADIO_TEXT", 
"V4L2_CID_RDS_TX_PI", etc to handle FM TX RDS data?

Thanks and regards,
Pramodh




