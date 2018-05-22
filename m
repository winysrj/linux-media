Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:41785 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbeEVIUG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 04:20:06 -0400
MIME-Version: 1.0
In-Reply-To: <1526912506-18406-4-git-send-email-narmstrong@baylibre.com>
References: <1526912506-18406-1-git-send-email-narmstrong@baylibre.com> <1526912506-18406-4-git-send-email-narmstrong@baylibre.com>
From: Enric Balletbo Serra <eballetbo@gmail.com>
Date: Tue, 22 May 2018 10:20:05 +0200
Message-ID: <CAFqH_53kxTCMKjFvCUPvLEaZG9F3TCcsWV=9_nVXwyk0FONmPg@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] mfd: cros-ec: Introduce CEC commands and events definitions.
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: David Airlie <airlied@linux.ie>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lee Jones <lee.jones@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Sean Paul <seanpaul@google.com>, sadolfsson@google.com,
        intel-gfx@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Stefan Adolfsson <sadolfsson@chromium.org>,
        Fabien Parent <fparent@baylibre.com>,
        Felix Ekblom <felixe@google.com>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        Benson Leung <bleung@google.com>, darekm@google.com,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Neil,

2018-05-21 16:21 GMT+02:00 Neil Armstrong <narmstrong@baylibre.com>:
> The EC can expose a CEC bus, this patch adds the CEC related definitions
> needed by the cros-ec-cec driver.
> Having a 16 byte mkbp event size makes it possible to send CEC
> messages from the EC to the AP directly inside the mkbp event
> instead of first doing a notification and then a read.
>
> Signed-off-by: Stefan Adolfsson <sadolfsson@chromium.org>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/platform/chrome/cros_ec_proto.c |  40 ++++++++++---
>  include/linux/mfd/cros_ec.h             |   2 +-
>  include/linux/mfd/cros_ec_commands.h    | 103 ++++++++++++++++++++++++++++++++
>  3 files changed, 135 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> index e7bbdf9..c4f6c44 100644
> --- a/drivers/platform/chrome/cros_ec_proto.c
> +++ b/drivers/platform/chrome/cros_ec_proto.c
> @@ -504,10 +504,31 @@ int cros_ec_cmd_xfer_status(struct cros_ec_device *ec_dev,
>  }
>  EXPORT_SYMBOL(cros_ec_cmd_xfer_status);
>
> +static int get_next_event_xfer(struct cros_ec_device *ec_dev,
> +                              struct cros_ec_command *msg,
> +                              int version, uint32_t size)
> +{
> +       int ret;
> +
> +       msg->version = version;
> +       msg->command = EC_CMD_GET_NEXT_EVENT;
> +       msg->insize = size;
> +       msg->outsize = 0;
> +
> +       ret = cros_ec_cmd_xfer(ec_dev, msg);
> +       if (ret > 0) {
> +               ec_dev->event_size = ret - 1;
> +               memcpy(&ec_dev->event_data, msg->data, ec_dev->event_size);
> +       }
> +
> +       return ret;
> +}
> +
>  static int get_next_event(struct cros_ec_device *ec_dev)
>  {
>         u8 buffer[sizeof(struct cros_ec_command) + sizeof(ec_dev->event_data)];
>         struct cros_ec_command *msg = (struct cros_ec_command *)&buffer;
> +       static int cmd_version = 1;
>         int ret;
>
>         if (ec_dev->suspended) {
> @@ -515,18 +536,19 @@ static int get_next_event(struct cros_ec_device *ec_dev)
>                 return -EHOSTDOWN;
>         }
>
> -       msg->version = 0;
> -       msg->command = EC_CMD_GET_NEXT_EVENT;
> -       msg->insize = sizeof(ec_dev->event_data);
> -       msg->outsize = 0;
> +       if (cmd_version == 1) {
> +               ret = get_next_event_xfer(ec_dev, msg, cmd_version,
> +                               sizeof(struct ec_response_get_next_event_v1));
> +               if (ret < 0 || msg->result != EC_RES_INVALID_VERSION)
> +                       return ret;
>

Thinking a bit more, there is a command to ask supported command
versions (EC_CMD_GET_CMD_VERSION). So, i theory you should be able to
ask for the versions supported by the command, see for example what is
done in [1], [2] and [3]. Anyway I am fine with this for now, and
after do some test seems that nothing breaks, so

Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>

Thanks,
 Enric

[1] https://chromium.googlesource.com/chromiumos/platform/ec/+/master/util/misc_util.c#98
[2] https://chromium.googlesource.com/chromiumos/platform/ec/+/master/util/misc_util.c#131
[3] https://chromium.googlesource.com/chromiumos/platform/ec/+/master/util/ectool.c#786


> -       ret = cros_ec_cmd_xfer(ec_dev, msg);
> -       if (ret > 0) {
> -               ec_dev->event_size = ret - 1;
> -               memcpy(&ec_dev->event_data, msg->data,
> -                      sizeof(ec_dev->event_data));
> +               /* Fallback to version 0 for future send attempts */
> +               cmd_version = 0;
>         }
>
> +       ret = get_next_event_xfer(ec_dev, msg, cmd_version,
> +                                 sizeof(struct ec_response_get_next_event));
> +
>         return ret;
>  }
>
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index f36125e..32caef3 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -147,7 +147,7 @@ struct cros_ec_device {
>         bool mkbp_event_supported;
>         struct blocking_notifier_head event_notifier;
>
> -       struct ec_response_get_next_event event_data;
> +       struct ec_response_get_next_event_v1 event_data;
>         int event_size;
>         u32 host_event_wake_mask;
>  };
> diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
> index f2edd99..9b8bc4a 100644
> --- a/include/linux/mfd/cros_ec_commands.h
> +++ b/include/linux/mfd/cros_ec_commands.h
> @@ -804,6 +804,8 @@ enum ec_feature_code {
>         EC_FEATURE_MOTION_SENSE_FIFO = 24,
>         /* EC has RTC feature that can be controlled by host commands */
>         EC_FEATURE_RTC = 27,
> +       /* EC supports CEC commands */
> +       EC_FEATURE_CEC = 35,
>  };
>
>  #define EC_FEATURE_MASK_0(event_code) (1UL << (event_code % 32))
> @@ -2078,6 +2080,12 @@ enum ec_mkbp_event {
>         /* EC sent a sysrq command */
>         EC_MKBP_EVENT_SYSRQ = 6,
>
> +       /* Notify the AP that something happened on CEC */
> +       EC_MKBP_CEC_EVENT = 8,
> +
> +       /* Send an incoming CEC message to the AP */
> +       EC_MKBP_EVENT_CEC_MESSAGE = 9,
> +
>         /* Number of MKBP events */
>         EC_MKBP_EVENT_COUNT,
>  };
> @@ -2093,12 +2101,31 @@ union ec_response_get_next_data {
>         uint32_t   sysrq;
>  } __packed;
>
> +union ec_response_get_next_data_v1 {
> +       uint8_t   key_matrix[16];
> +
> +       /* Unaligned */
> +       uint32_t  host_event;
> +
> +       uint32_t   buttons;
> +       uint32_t   switches;
> +       uint32_t   sysrq;
> +       uint32_t   cec_events;
> +       uint8_t    cec_message[16];
> +} __packed;
> +
>  struct ec_response_get_next_event {
>         uint8_t event_type;
>         /* Followed by event data if any */
>         union ec_response_get_next_data data;
>  } __packed;
>
> +struct ec_response_get_next_event_v1 {
> +       uint8_t event_type;
> +       /* Followed by event data if any */
> +       union ec_response_get_next_data_v1 data;
> +} __packed;
> +
>  /* Bit indices for buttons and switches.*/
>  /* Buttons */
>  #define EC_MKBP_POWER_BUTTON   0
> @@ -2828,6 +2855,82 @@ struct ec_params_reboot_ec {
>  /* Current version of ACPI memory address space */
>  #define EC_ACPI_MEM_VERSION_CURRENT 1
>
> +/*****************************************************************************/
> +/*
> + * HDMI CEC commands
> + *
> + * These commands are for sending and receiving message via HDMI CEC
> + */
> +#define MAX_CEC_MSG_LEN 16
> +
> +/* CEC message from the AP to be written on the CEC bus */
> +#define EC_CMD_CEC_WRITE_MSG 0x00B8
> +
> +/**
> + * struct ec_params_cec_write - Message to write to the CEC bus
> + * @msg: message content to write to the CEC bus
> + */
> +struct ec_params_cec_write {
> +       uint8_t msg[MAX_CEC_MSG_LEN];
> +} __packed;
> +
> +/* Set various CEC parameters */
> +#define EC_CMD_CEC_SET 0x00BA
> +
> +/**
> + * struct ec_params_cec_set - CEC parameters set
> + * @cmd: parameter type, can be CEC_CMD_ENABLE or CEC_CMD_LOGICAL_ADDRESS
> + * @enable: in case cmd is CEC_CMD_ENABLE, this field can be 0 to disable CEC
> + *     or 1 to enable CEC functionnality
> + * @address: in case cmd is CEC_CMD_LOGICAL_ADDRESS, this field encodes the
> + *     requested logical address between 0 and 15 or 0xff to unregister
> + */
> +struct ec_params_cec_set {
> +       uint8_t cmd; /* enum cec_command */
> +       union {
> +               uint8_t enable;
> +               uint8_t address;
> +       };
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
> +       uint8_t cmd; /* enum cec_command */
> +} __packed;
> +
> +/**
> + * struct ec_response_cec_get - CEC parameters get response
> + * @enable: in case cmd was CEC_CMD_ENABLE, this field will 0 if CEC is
> + *     disabled or 1 if CEC functionnality is enabled
> + * @address: in case cmd was CEC_CMD_LOGICAL_ADDRESS, this will encode the
> + *     configured logical address between 0 and 15 or 0xff if unregistered
> + */
> +struct ec_response_cec_get {
> +       union {
> +               uint8_t enable;
> +               uint8_t address;
> +       };
> +} __packed;
> +
> +/* CEC parameters command */
> +enum cec_command {
> +       /* CEC reading, writing and events enable */
> +       CEC_CMD_ENABLE,
> +       /* CEC logical address  */
> +       CEC_CMD_LOGICAL_ADDRESS,
> +};
> +
> +/* Events from CEC to AP */
> +enum mkbp_cec_event {
> +       EC_MKBP_CEC_SEND_OK                     = BIT(0),
> +       EC_MKBP_CEC_SEND_FAILED                 = BIT(1),
> +};
>
>  /*****************************************************************************/
>  /*
> --
> 2.7.4
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
