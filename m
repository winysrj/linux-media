Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53925 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751048AbdGPKqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Jul 2017 06:46:47 -0400
Subject: Re: [PATCH 4/4] drm/vc4: add HDMI CEC support
To: Eric Anholt <eric@anholt.net>, linux-media@vger.kernel.org
References: <20170711112021.38525-1-hverkuil@xs4all.nl>
 <20170711112021.38525-5-hverkuil@xs4all.nl>
 <87d195h41b.fsf@eliezer.anholt.net>
 <c45868d2-50e5-987b-db1e-b8e76983cbb2@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e8289d89-bfd5-d964-2b9a-2d36394ce868@xs4all.nl>
Date: Sun, 16 Jul 2017 12:46:42 +0200
MIME-Version: 1.0
In-Reply-To: <c45868d2-50e5-987b-db1e-b8e76983cbb2@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/17 21:43, Hans Verkuil wrote:
> On 12/07/17 21:02, Eric Anholt wrote:
>>> +static int vc4_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>>> +				      u32 signal_free_time, struct cec_msg *msg)
>>> +{
>>> +	struct vc4_dev *vc4 = cec_get_drvdata(adap);
>>> +	u32 val;
>>> +	unsigned int i;
>>> +
>>> +	for (i = 0; i < msg->len; i += 4)
>>> +		HDMI_WRITE(VC4_HDMI_CEC_TX_DATA_1 + i,
>>> +			   (msg->msg[i]) |
>>> +			   (msg->msg[i + 1] << 8) |
>>> +			   (msg->msg[i + 2] << 16) |
>>> +			   (msg->msg[i + 3] << 24));
>>> +
>>> +	val = HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
>>> +	val &= ~VC4_HDMI_CEC_START_XMIT_BEGIN;
>>> +	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
>>> +	val &= ~VC4_HDMI_CEC_MESSAGE_LENGTH_MASK;
>>> +	val |= (msg->len - 1) << VC4_HDMI_CEC_MESSAGE_LENGTH_SHIFT;
>>> +	val |= VC4_HDMI_CEC_START_XMIT_BEGIN;
>>
>> It doesn't look to me like len should have 1 subtracted from it.  The
>> field has 4 bits for our up-to-16-byte length, and the firmware seems to
>> be setting it to the same value as a memcpy for the message data uses.
> 
> You need to subtract by one. The CEC protocol supports messages of 1-16
> bytes in length. Since the message length mask is only 4 bits you need to
> encode this in the value 0-15. Hence the '-1', otherwise you would never
> be able to send 16 byte messages.
> 
> I actually found this when debugging the messages it was transmitting: they
> were one too long.
> 
> This suggests that the firmware does this wrong. I don't have time tomorrow,
> but I'll see if I can do a quick test on Friday to verify that.

I double-checked this and both the driver and the firmware do the right thing.
Just to be certain I also tried sending a message that uses the full 16 byte
payload and that too went well. So the code is definitely correct.

Regards,

	Hans
