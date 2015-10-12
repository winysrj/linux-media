Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34080 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbJLMd5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 08:33:57 -0400
Received: by lbbck17 with SMTP id ck17so21148418lbb.1
        for <linux-media@vger.kernel.org>; Mon, 12 Oct 2015 05:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <561B906F.9020508@xs4all.nl>
References: <cover.1441633456.git.hansverk@cisco.com> <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com>
 <20151005223207.GM21513@n2100.arm.linux.org.uk> <561B906F.9020508@xs4all.nl>
From: Kamil Debski <kamil@wypas.org>
Date: Mon, 12 Oct 2015 14:33:16 +0200
Message-ID: <CAP3TMiFj47GMYEqnNTXQv3vKbwnDGKhRDcMrwTY42RVUH-_d4Q@mail.gmail.com>
Subject: Re: [PATCHv9 14/15] cec: s5p-cec: Add s5p-cec driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, sean@mess.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12 October 2015 at 12:50, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 10/06/2015 12:32 AM, Russell King - ARM Linux wrote:
>> On Mon, Sep 07, 2015 at 03:44:43PM +0200, Hans Verkuil wrote:
>>> +    if (status & CEC_STATUS_TX_DONE) {
>>> +            if (status & CEC_STATUS_TX_ERROR) {
>>> +                    dev_dbg(cec->dev, "CEC_STATUS_TX_ERROR set\n");
>>> +                    cec->tx = STATE_ERROR;
>>> +            } else {
>>> +                    dev_dbg(cec->dev, "CEC_STATUS_TX_DONE\n");
>>> +                    cec->tx = STATE_DONE;
>>> +            }
>>> +            s5p_clr_pending_tx(cec);
>>> +    }
>>
>> Your CEC implementation seems to be written around the idea that there
>> are only two possible outcomes from a CEC message - "done" and "error",
>> which get translated to:
>
> This code is for the Samsung exynos CEC implementation. Marek, is this all
> that the exynos CEC hardware returns?

The possible status values that are implemented in the CEC framework
are following:

+/* cec status field */
+#define CEC_TX_STATUS_OK               (0)
+#define CEC_TX_STATUS_ARB_LOST         (1 << 0)
+#define CEC_TX_STATUS_RETRY_TIMEOUT    (1 << 1)
+#define CEC_TX_STATUS_FEATURE_ABORT    (1 << 2)
+#define CEC_TX_STATUS_REPLY_TIMEOUT    (1 << 3)
+#define CEC_RX_STATUS_READY            (0)

The only two ones I could match with the Exynos CEC module status bits are
CEC_TX_STATUS_OK and  CEC_TX_STATUS_RETRY_TIMEOUT.

The status bits in Exynos HW are:
- Tx_Error
- Tx_Done
- Tx_Transferring
- Tx_Running
- Tx_Bytes_Transferred

- Tx_Wait
- Tx_Sending_Status_Bit
- Tx_Sending_Hdr_Blk
- Tx_Sending_Data_Blk
- Tx_Latest_Initiator

- Tx_Wait_SFT_Succ
- Tx_Wait_SFT_New
- Tx_Wait_SFT_Retran
- Tx_Retrans_Cnt
- Tx_ACK_Failed

>
>>
>>> +    case STATE_DONE:
>>> +            cec_transmit_done(cec->adap, CEC_TX_STATUS_OK);
>>> +            cec->tx = STATE_IDLE;
>>> +            break;
>>> +    case STATE_ERROR:
>>> +            cec_transmit_done(cec->adap, CEC_TX_STATUS_RETRY_TIMEOUT);
>>> +            cec->tx = STATE_IDLE;
>>
>> "okay" and "retry_timeout".  So, if we have an adapter which can report
>> (eg) a NACK, we have to report it as the obscure "retry timeout" status?
>> Why this obscure naming - why can't we have something that uses the
>> terminology in the spec?
>>
>
> Actually, a NACK should lead to a re-transmission (up to 5 times), see CEC 7.1.
> The assumption of the CEC framework is that this is done by the CEC adapter
> driver, not by the framework. So if after repeated retransmissions there is
> still no Ack, the CEC_TX_STATUS_RETRY_TIMEOUT error is returned. I could
> change this to _MAX_RETRIES_REACHED if you prefer.
>
> The CEC_TX_STATUS_ macros were based on what the adv drivers support (except
> for CEC_TX_STATUS_REPLY_TIMEOUT which is specific to the framework).
>
> Regards,
>
>         Hans

Best wishes,
Kamil
