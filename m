Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36412 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932645AbcINM6u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 08:58:50 -0400
Subject: Re: [PATCH v2 2/4] add stih-cec driver
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org
References: <1473852249-15960-1-git-send-email-benjamin.gaignard@linaro.org>
 <1473852249-15960-3-git-send-email-benjamin.gaignard@linaro.org>
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <16e7882f-2975-281a-eb6e-f27c3ca76fa2@xs4all.nl>
Date: Wed, 14 Sep 2016 14:58:43 +0200
MIME-Version: 1.0
In-Reply-To: <1473852249-15960-3-git-send-email-benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

Just one comment:

On 09/14/2016 01:24 PM, Benjamin Gaignard wrote:
> This patch implement CEC driver for stih4xx platform.
> Driver compliance has been test with cec-ctl and
> cec-compliance tools.
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> ---
>  drivers/staging/media/Kconfig           |   2 +
>  drivers/staging/media/Makefile          |   1 +
>  drivers/staging/media/st-cec/Kconfig    |   8 +
>  drivers/staging/media/st-cec/Makefile   |   1 +
>  drivers/staging/media/st-cec/stih-cec.c | 382 ++++++++++++++++++++++++++++++++
>  5 files changed, 394 insertions(+)
>  create mode 100644 drivers/staging/media/st-cec/Kconfig
>  create mode 100644 drivers/staging/media/st-cec/Makefile
>  create mode 100644 drivers/staging/media/st-cec/stih-cec.c
> 

<snip>

> +static void stih_rx_done(struct stih_cec *cec, u32 status)
> +{
> +	struct cec_msg *msg = &cec->rx_msg;

You can just say:

	struct cec_msg msg = {};

and drop rx_msg.

> +	u8 i;
> +
> +	if (status & CEC_RX_ERROR_MIN)
> +		return;
> +
> +	if (status & CEC_RX_ERROR_MAX)
> +		return;
> +
> +	memset(msg, 0x00, sizeof(*msg));
> +	msg->len = readl(cec->regs + CEC_DATA_ARRAY_STATUS) & 0x1f;
> +
> +	if (!msg-len)
> +		return;
> +
> +	if (msg->len > 16)
> +		msg->len = 16;
> +
> +	for (i = 0; i < msg->len; i++)
> +		msg->msg[i] = readl(cec->regs + CEC_RX_DATA_BASE + i);
> +
> +	cec_received_msg(cec->adap, msg);

cec_received_msg will copy the contents, so it is OK if it is gone after
this call.

> +}

Regards,

	Hans
