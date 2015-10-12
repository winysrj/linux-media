Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39286 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750888AbbJLKwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 06:52:24 -0400
Message-ID: <561B906F.9020508@xs4all.nl>
Date: Mon, 12 Oct 2015 12:50:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 14/15] cec: s5p-cec: Add s5p-cec driver
References: <cover.1441633456.git.hansverk@cisco.com> <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com> <20151005223207.GM21513@n2100.arm.linux.org.uk>
In-Reply-To: <20151005223207.GM21513@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2015 12:32 AM, Russell King - ARM Linux wrote:
> On Mon, Sep 07, 2015 at 03:44:43PM +0200, Hans Verkuil wrote:
>> +	if (status & CEC_STATUS_TX_DONE) {
>> +		if (status & CEC_STATUS_TX_ERROR) {
>> +			dev_dbg(cec->dev, "CEC_STATUS_TX_ERROR set\n");
>> +			cec->tx = STATE_ERROR;
>> +		} else {
>> +			dev_dbg(cec->dev, "CEC_STATUS_TX_DONE\n");
>> +			cec->tx = STATE_DONE;
>> +		}
>> +		s5p_clr_pending_tx(cec);
>> +	}
> 
> Your CEC implementation seems to be written around the idea that there
> are only two possible outcomes from a CEC message - "done" and "error",
> which get translated to:

This code is for the Samsung exynos CEC implementation. Marek, is this all
that the exynos CEC hardware returns?

> 
>> +	case STATE_DONE:
>> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_OK);
>> +		cec->tx = STATE_IDLE;
>> +		break;
>> +	case STATE_ERROR:
>> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_RETRY_TIMEOUT);
>> +		cec->tx = STATE_IDLE;
> 
> "okay" and "retry_timeout".  So, if we have an adapter which can report
> (eg) a NACK, we have to report it as the obscure "retry timeout" status?
> Why this obscure naming - why can't we have something that uses the
> terminology in the spec?
> 

Actually, a NACK should lead to a re-transmission (up to 5 times), see CEC 7.1.
The assumption of the CEC framework is that this is done by the CEC adapter
driver, not by the framework. So if after repeated retransmissions there is
still no Ack, the CEC_TX_STATUS_RETRY_TIMEOUT error is returned. I could
change this to _MAX_RETRIES_REACHED if you prefer.

The CEC_TX_STATUS_ macros were based on what the adv drivers support (except
for CEC_TX_STATUS_REPLY_TIMEOUT which is specific to the framework).

Regards,

	Hans
