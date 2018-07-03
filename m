Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52164 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754500AbeGCJnr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2018 05:43:47 -0400
Received: by mail-wm0-f65.google.com with SMTP id s12-v6so1602380wmc.1
        for <linux-media@vger.kernel.org>; Tue, 03 Jul 2018 02:43:47 -0700 (PDT)
Date: Tue, 3 Jul 2018 10:43:44 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, olof@lixom.net,
        seanpaul@google.com, sadolfsson@google.com, felixe@google.com,
        bleung@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, eballetbo@gmail.com,
        Stefan Adolfsson <sadolfsson@chromium.org>
Subject: Re: [PATCH v7 3/6] mfd: cros-ec: Increase maximum mkbp event size
Message-ID: <20180703094344.GR20176@dell>
References: <1527841154-24832-1-git-send-email-narmstrong@baylibre.com>
 <1527841154-24832-4-git-send-email-narmstrong@baylibre.com>
 <20180618074443.GK31141@dell>
 <017e4688-4036-e606-7220-2e472afa0aac@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <017e4688-4036-e606-7220-2e472afa0aac@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jun 2018, Neil Armstrong wrote:

> Hi Lee,
> 
> On 18/06/2018 09:44, Lee Jones wrote:
> > On Fri, 01 Jun 2018, Neil Armstrong wrote:
> > 
> >> Having a 16 byte mkbp event size makes it possible to send CEC
> >> messages from the EC to the AP directly inside the mkbp event
> >> instead of first doing a notification and then a read.
> >>
> >> Signed-off-by: Stefan Adolfsson <sadolfsson@chromium.org>
> >> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> >> Tested-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> >> ---
> >>  drivers/platform/chrome/cros_ec_proto.c | 40 +++++++++++++++++++++++++--------
> >>  include/linux/mfd/cros_ec.h             |  2 +-
> >>  include/linux/mfd/cros_ec_commands.h    | 19 ++++++++++++++++
> >>  3 files changed, 51 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> >> index e7bbdf9..c4f6c44 100644
> >> --- a/drivers/platform/chrome/cros_ec_proto.c
> >> +++ b/drivers/platform/chrome/cros_ec_proto.c
> >> @@ -504,10 +504,31 @@ int cros_ec_cmd_xfer_status(struct cros_ec_device *ec_dev,
> >>  }
> >>  EXPORT_SYMBOL(cros_ec_cmd_xfer_status);
> >>  
> >> +static int get_next_event_xfer(struct cros_ec_device *ec_dev,
> >> +			       struct cros_ec_command *msg,
> >> +			       int version, uint32_t size)
> >> +{
> >> +	int ret;
> >> +
> >> +	msg->version = version;
> >> +	msg->command = EC_CMD_GET_NEXT_EVENT;
> >> +	msg->insize = size;
> >> +	msg->outsize = 0;
> >> +
> >> +	ret = cros_ec_cmd_xfer(ec_dev, msg);
> >> +	if (ret > 0) {
> >> +		ec_dev->event_size = ret - 1;
> >> +		memcpy(&ec_dev->event_data, msg->data, ec_dev->event_size);
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> >>  static int get_next_event(struct cros_ec_device *ec_dev)
> >>  {
> >>  	u8 buffer[sizeof(struct cros_ec_command) + sizeof(ec_dev->event_data)];
> >>  	struct cros_ec_command *msg = (struct cros_ec_command *)&buffer;
> >> +	static int cmd_version = 1;
> >>  	int ret;
> >>  
> >>  	if (ec_dev->suspended) {
> >> @@ -515,18 +536,19 @@ static int get_next_event(struct cros_ec_device *ec_dev)
> >>  		return -EHOSTDOWN;
> >>  	}
> >>  
> >> -	msg->version = 0;
> >> -	msg->command = EC_CMD_GET_NEXT_EVENT;
> >> -	msg->insize = sizeof(ec_dev->event_data);
> >> -	msg->outsize = 0;
> >> +	if (cmd_version == 1) {
> >> +		ret = get_next_event_xfer(ec_dev, msg, cmd_version,
> >> +				sizeof(struct ec_response_get_next_event_v1));
> >> +		if (ret < 0 || msg->result != EC_RES_INVALID_VERSION)
> >> +			return ret;
> >>  
> >> -	ret = cros_ec_cmd_xfer(ec_dev, msg);
> >> -	if (ret > 0) {
> >> -		ec_dev->event_size = ret - 1;
> >> -		memcpy(&ec_dev->event_data, msg->data,
> >> -		       sizeof(ec_dev->event_data));
> >> +		/* Fallback to version 0 for future send attempts */
> >> +		cmd_version = 0;
> >>  	}
> >>  
> >> +	ret = get_next_event_xfer(ec_dev, msg, cmd_version,
> >> +				  sizeof(struct ec_response_get_next_event));
> >> +
> >>  	return ret;
> >>  }
> >>  
> >> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> >> index f36125e..32caef3 100644
> >> --- a/include/linux/mfd/cros_ec.h
> >> +++ b/include/linux/mfd/cros_ec.h
> >> @@ -147,7 +147,7 @@ struct cros_ec_device {
> >>  	bool mkbp_event_supported;
> >>  	struct blocking_notifier_head event_notifier;
> >>  
> >> -	struct ec_response_get_next_event event_data;
> >> +	struct ec_response_get_next_event_v1 event_data;
> >>  	int event_size;
> >>  	u32 host_event_wake_mask;
> >>  };
> >> diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
> >> index f2edd99..cc0768e 100644
> >> --- a/include/linux/mfd/cros_ec_commands.h
> >> +++ b/include/linux/mfd/cros_ec_commands.h
> >> @@ -2093,12 +2093,31 @@ union ec_response_get_next_data {
> >>  	uint32_t   sysrq;
> >>  } __packed;
> >>  
> >> +union ec_response_get_next_data_v1 {
> >> +	uint8_t   key_matrix[16];
> >> +
> >> +	/* Unaligned */
> > 
> > That's funny!
> > 
> >> +	uint32_t  host_event;
> >> +
> >> +	uint32_t   buttons;
> >> +	uint32_t   switches;
> >> +	uint32_t   sysrq;
> >> +	uint32_t   cec_events;
> >> +	uint8_t    cec_message[16];
> > 
> > Since there are some whitespace alignment issues in here.

Fix the white space issues.

> >> +} __packed;
> > 
> > How come these guys have kerneldoc headers?

Consider using kerneldoc headers (not required for this patch).

> Can you explicit what should be changed here ?

-^

> >>  struct ec_response_get_next_event {
> >>  	uint8_t event_type;
> >>  	/* Followed by event data if any */
> >>  	union ec_response_get_next_data data;
> >>  } __packed;
> >>  
> >> +struct ec_response_get_next_event_v1 {
> >> +	uint8_t event_type;
> >> +	/* Followed by event data if any */
> >> +	union ec_response_get_next_data_v1 data;
> >> +} __packed;
> >> +
> >>  /* Bit indices for buttons and switches.*/
> >>  /* Buttons */
> >>  #define EC_MKBP_POWER_BUTTON	0
> > 
> 

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
