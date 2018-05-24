Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:35093 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965456AbeEXJLS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 05:11:18 -0400
Subject: Re: [PATCH v5 4/6] mfd: cros-ec: Introduce CEC commands and events
 definitions.
To: Neil Armstrong <narmstrong@baylibre.com>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        eballetbo@gmail.com
References: <1527152101-17278-1-git-send-email-narmstrong@baylibre.com>
 <1527152101-17278-5-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bb0b5060-5ccc-814c-5256-53151a831178@xs4all.nl>
Date: Thu, 24 May 2018 11:11:16 +0200
MIME-Version: 1.0
In-Reply-To: <1527152101-17278-5-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/05/18 10:54, Neil Armstrong wrote:
> The EC can expose a CEC bus, this patch adds the CEC related definitions
> needed by the cros-ec-cec driver.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> ---
>  include/linux/mfd/cros_ec_commands.h | 85 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
> index cc0768e..ea9646f 100644
> --- a/include/linux/mfd/cros_ec_commands.h
> +++ b/include/linux/mfd/cros_ec_commands.h
> @@ -804,6 +804,8 @@ enum ec_feature_code {
>  	EC_FEATURE_MOTION_SENSE_FIFO = 24,
>  	/* EC has RTC feature that can be controlled by host commands */
>  	EC_FEATURE_RTC = 27,
> +	/* EC supports CEC commands */
> +	EC_FEATURE_CEC = 35,
>  };
>  
>  #define EC_FEATURE_MASK_0(event_code) (1UL << (event_code % 32))
> @@ -2078,6 +2080,12 @@ enum ec_mkbp_event {
>  	/* EC sent a sysrq command */
>  	EC_MKBP_EVENT_SYSRQ = 6,
>  
> +	/* Notify the AP that something happened on CEC */
> +	EC_MKBP_CEC_EVENT = 8,
> +
> +	/* Send an incoming CEC message to the AP */
> +	EC_MKBP_EVENT_CEC_MESSAGE = 9,
> +
>  	/* Number of MKBP events */
>  	EC_MKBP_EVENT_COUNT,
>  };
> @@ -2850,6 +2858,83 @@ struct ec_params_reboot_ec {
>  
>  /*****************************************************************************/
>  /*
> + * HDMI CEC commands
> + *
> + * These commands are for sending and receiving message via HDMI CEC
> + */
> +#define MAX_CEC_MSG_LEN 16

Can you rename this to EC_MAX_CEC_MSG_LEN? It is way too similar to the
CEC_MAX_MSG_LEN defined in cec.h. Since this is a property of the EC hw/fw
it makes sense to prefix it accordingly.

> +
> +/* CEC message from the AP to be written on the CEC bus */
> +#define EC_CMD_CEC_WRITE_MSG 0x00B8
> +
> +/**
> + * struct ec_params_cec_write - Message to write to the CEC bus
> + * @msg: message content to write to the CEC bus
> + */
> +struct ec_params_cec_write {
> +	uint8_t msg[MAX_CEC_MSG_LEN];
> +} __packed;
> +
> +/* Set various CEC parameters */
> +#define EC_CMD_CEC_SET 0x00BA
> +
> +/**
> + * struct ec_params_cec_set - CEC parameters set
> + * @cmd: parameter type, can be CEC_CMD_ENABLE or CEC_CMD_LOGICAL_ADDRESS
> + * @enable: in case cmd is CEC_CMD_ENABLE, this field can be 0 to disable CEC
> + * 	or 1 to enable CEC functionnality
> + * @address: in case cmd is CEC_CMD_LOGICAL_ADDRESS, this field encodes the
> + *	requested logical address between 0 and 15 or 0xff to unregister
> + */
> +struct ec_params_cec_set {
> +	uint8_t cmd; /* enum cec_command */
> +	union {
> +		uint8_t enable;
> +		uint8_t address;
> +	};
> +} __packed;
> +
> +/* Read various CEC parameters */
> +#define EC_CMD_CEC_GET 0x00BB
> +
> +/**
> + * struct ec_params_cec_get - CEC parameters get
> + * @cmd: parameter type, can be CEC_CMD_ENABLE or CEC_CMD_LOGICAL_ADDRESS
> + */
> +struct ec_params_cec_get {
> +	uint8_t cmd; /* enum cec_command */
> +} __packed;
> +
> +/**
> + * struct ec_response_cec_get - CEC parameters get response
> + * @enable: in case cmd was CEC_CMD_ENABLE, this field will 0 if CEC is
> + * 	disabled or 1 if CEC functionnality is enabled
> + * @address: in case cmd was CEC_CMD_LOGICAL_ADDRESS, this will encode the
> + *	configured logical address between 0 and 15 or 0xff if unregistered
> + */
> +struct ec_response_cec_get {
> +	union {
> +		uint8_t enable;
> +		uint8_t address;
> +	};
> +} __packed;
> +
> +/* CEC parameters command */
> +enum cec_command {

Same here: shouldn't all of this be prefixed with ec_ or EC_?

Regards,

	Hans

> +	/* CEC reading, writing and events enable */
> +	CEC_CMD_ENABLE,
> +	/* CEC logical address  */
> +	CEC_CMD_LOGICAL_ADDRESS,
> +};
> +
> +/* Events from CEC to AP */
> +enum mkbp_cec_event {
> +	EC_MKBP_CEC_SEND_OK			= BIT(0),
> +	EC_MKBP_CEC_SEND_FAILED			= BIT(1),
> +};
> +
> +/*****************************************************************************/
> +/*
>   * Special commands
>   *
>   * These do not follow the normal rules for commands.  See each command for
> 
