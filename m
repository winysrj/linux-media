Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:12040 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeJSVZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 17:25:53 -0400
Subject: Re: [PATCH v3 1/2] media: add SECO cec driver
To: ektor5 <ek5.chimenti@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: luca.pisani@udoo.org, jose.abreu@synopsys.com, sean@mess.org,
        sakari.ailus@linux.intel.com, jacopo@jmondi.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <cover.1539807092.git.ek5.chimenti@gmail.com>
 <3682be6c6cf7263f165080b9a1123017a23489a0.1539807092.git.ek5.chimenti@gmail.com>
 <d874bf66-e4ad-0c98-711d-3c79d0342a67@xs4all.nl>
 <20181019130205.lqb3sopqqangefr4@Ettosoft-T55>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <0ae193a7-b651-0564-c4de-a159b1e2bfb2@cisco.com>
Date: Fri, 19 Oct 2018 15:19:45 +0200
MIME-Version: 1.0
In-Reply-To: <20181019130205.lqb3sopqqangefr4@Ettosoft-T55>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/18 15:02, ektor5 wrote:
> Hi Hans,
> 
> On Thu, Oct 18, 2018 at 09:14:55AM +0200, Hans Verkuil wrote:
>> Hi Ettore,
>>
>> Just a few small things and it is ready to go:
>>
>> On 10/17/2018 11:31 PM, ektor5 wrote:
>>> From: Ettore Chimenti <ek5.chimenti@gmail.com>
>>>
>>> This patch adds support to the CEC device implemented with a STM32
>>> microcontroller in X86 SECO Boards, including UDOO X86.
>>>
>>> The communication is achieved via Braswell integrated SMBus
>>> (i2c-i801). The driver use direct access to the PCI addresses, due to
>>> the limitations of the specific driver in presence of ACPI calls.
>>>
>>> The basic functionalities are tested with success with cec-ctl and
>>> cec-compliance.
>>>
>>> Inspired by cros-ec-cec implementation, attaches to i915 driver
>>> cec-notifier.
>>>
>>> Signed-off-by: Ettore Chimenti <ek5.chimenti@gmail.com>
>>> ---
>>>  MAINTAINERS                                |   6 +
>>>  drivers/media/platform/Kconfig             |  12 +
>>>  drivers/media/platform/Makefile            |   2 +
>>>  drivers/media/platform/seco-cec/Makefile   |   1 +
>>>  drivers/media/platform/seco-cec/seco-cec.c | 699 +++++++++++++++++++++
>>>  drivers/media/platform/seco-cec/seco-cec.h | 130 ++++
>>>  6 files changed, 850 insertions(+)
>>>  create mode 100644 drivers/media/platform/seco-cec/Makefile
>>>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.c
>>>  create mode 100644 drivers/media/platform/seco-cec/seco-cec.h

<snip>

>>> +static int secocec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
>>> +{
>>> +	u16 enable_val = 0;
>>> +	int status;
>>
>> If logical_addr == CEC_LOG_ADDR_INVALID, then this function must not return
>> an error or the CEC framework will WARN about it.
>>
>>> +
>>> +	/* Disable device */
>>> +	status = smb_rd16(SECOCEC_ENABLE_REG_1, &enable_val);
>>> +	if (status)
>>> +		return status;
>>> +
>>> +	status = smb_wr16(SECOCEC_ENABLE_REG_1,
>>> +			  enable_val & ~SECOCEC_ENABLE_REG_1_CEC);
>>> +	if (status)
>>> +		return status;
>>> +
>>> +	/* Write logical address */
>>> +	status = smb_wr16(SECOCEC_DEVICE_LA, logical_addr);
>>
>> So does writing CEC_LOG_ADDR_INVALID (0xff) invalidate all logical
>> addresses? I see no special code for that. If that is indeed the
>> case, then you should document this.
> 
> The micro can have only one LA at a time. 
> 
> In the micro datasheet there isn't any reference to an invalid addr, so
> it shouldn't complain. It will just set LA = 0xf. Is this correct or it
> should disable the device instead?

Setting it to 0xf is OK, but you might want to write 'logical_addr & 0xf'
to the register with a note that CEC_LOG_ADDR_INVALID is mapped to the
'Unregistered' logical address.

> 
>>
>>> +	if (status)
>>> +		return status;
>>> +
>>> +	/* Re-enable device */
>>> +	status = smb_wr16(SECOCEC_ENABLE_REG_1,
>>> +			  enable_val | SECOCEC_ENABLE_REG_1_CEC);
>>> +	if (status)
>>> +		return status;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int secocec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>>> +				 u32 signal_free_time, struct cec_msg *msg)
>>> +{
>>> +	struct secocec_data *cec = cec_get_drvdata(adap);
>>> +	struct device *dev = cec->dev;
>>> +	u16 payload_len, payload_id_len, destination, val = 0;
>>> +	u8 *payload_msg;
>>> +	int status;
>>> +	u8 i;
>>> +
>>> +	/* Device msg len already accounts for header */
>>> +	payload_id_len = msg->len - 1;
>>> +
>>> +	/* Send data length */
>>> +	status = smb_wr16(SECOCEC_WRITE_DATA_LENGTH, payload_id_len);
>>> +	if (status)
>>> +		goto err;
>>> +
>>> +	/* Send Operation ID if present */
>>> +	if (payload_id_len > 0) {
>>> +		status = smb_wr16(SECOCEC_WRITE_OPERATION_ID, msg->msg[1]);
>>> +		if (status)
>>> +			goto err;
>>> +	}
>>> +	/* Send data if present */
>>> +	if (payload_id_len > 1) {
>>> +		/* Only data; */
>>> +		payload_len = msg->len - 2;
>>> +		payload_msg = &msg->msg[2];
>>> +
>>> +		/* Copy message into registers */
>>> +		for (i = 0; i < payload_len; i += 2) {
>>> +			/* hi byte */
>>> +			val = payload_msg[i + 1] << 8;
>>> +
>>> +			/* lo byte */
>>> +			val |= payload_msg[i];
>>> +
>>> +			status = smb_wr16(SECOCEC_WRITE_DATA_00 + i / 2, val);
>>> +			if (status)
>>> +				goto err;
>>> +		}
>>> +	}
>>> +	/* Send msg source/destination and fire msg */
>>> +	destination = msg->msg[0];
>>> +	status = smb_wr16(SECOCEC_WRITE_BYTE0, destination);
>>> +	if (status)
>>> +		goto err;
>>> +
>>> +	return 0;
>>> +
>>> +err:
>>> +	dev_err(dev, "Transmit failed (%d)", status);
>>
>> You can drop this: the cec module has already debug code for that.
>>
>>> +	return status;
>>> +}
>>> +
>>> +static int secocec_tx_done(struct cec_adapter *adap, u16 status_val)
>>
>> Just return void since the return code is ignored anyway.
> 
> Ok, will drop those.
> 
>>
>>> +{
>>> +	int status = 0;
>>> +
>>> +	if (status_val & SECOCEC_STATUS_TX_ERROR_MASK) {
>>> +		if (status_val & SECOCEC_STATUS_TX_NACK_ERROR) {
>>> +			cec_transmit_attempt_done(adap, CEC_TX_STATUS_NACK);
>>> +			status = -EAGAIN;
>>> +		} else {
>>> +			cec_transmit_attempt_done(adap, CEC_TX_STATUS_ERROR);
>>> +			status = -EIO;
>>> +		}
>>> +	} else {
>>> +		cec_transmit_attempt_done(adap, CEC_TX_STATUS_OK);
>>> +	}
>>> +
>>> +	/* Reset status reg */
>>> +	status_val = SECOCEC_STATUS_TX_ERROR_MASK |
>>> +		SECOCEC_STATUS_MSG_SENT_MASK |
>>> +		SECOCEC_STATUS_TX_NACK_ERROR;
>>> +	smb_wr16(SECOCEC_STATUS, status_val);
>>> +
>>> +	return status;
>>> +}
>>> +
>>> +static int secocec_rx_done(struct cec_adapter *adap, u16 status_val)
>>> +{
>>
>> Ditto.
>>
>>> +	struct secocec_data *cec = cec_get_drvdata(adap);
>>> +	struct device *dev = cec->dev;
>>> +	struct cec_msg msg = { };
>>> +	bool flag_overflow = false;
>>> +	u8 payload_len, i = 0;
>>> +	u8 *payload_msg;
>>> +	u16 val = 0;
>>> +	int status;
>>> +
>>> +	if (status_val & SECOCEC_STATUS_RX_OVERFLOW_MASK) {
>>> +		dev_warn(dev, "Received more than 16 bytes. Discarding");
>>
>> Is it better to just receive the first 16 bytes?
> 
> In case of an overflow, it should discard the overflowing bytes, but I
> don't have any equipment that can test this. (this device can send up to
> 16 bytes).

Add a note that this might not be necessary, but that you couldn't test
this. I can test it when I find some time.

> 
>>
>>> +		flag_overflow = true;
>>> +	}

Regards,

	Hans
