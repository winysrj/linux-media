Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:41245 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbJEWcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 18:32:22 -0400
Date: Mon, 5 Oct 2015 23:32:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 14/15] cec: s5p-cec: Add s5p-cec driver
Message-ID: <20151005223207.GM21513@n2100.arm.linux.org.uk>
References: <cover.1441633456.git.hansverk@cisco.com>
 <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 07, 2015 at 03:44:43PM +0200, Hans Verkuil wrote:
> +	if (status & CEC_STATUS_TX_DONE) {
> +		if (status & CEC_STATUS_TX_ERROR) {
> +			dev_dbg(cec->dev, "CEC_STATUS_TX_ERROR set\n");
> +			cec->tx = STATE_ERROR;
> +		} else {
> +			dev_dbg(cec->dev, "CEC_STATUS_TX_DONE\n");
> +			cec->tx = STATE_DONE;
> +		}
> +		s5p_clr_pending_tx(cec);
> +	}

Your CEC implementation seems to be written around the idea that there
are only two possible outcomes from a CEC message - "done" and "error",
which get translated to:

> +	case STATE_DONE:
> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_OK);
> +		cec->tx = STATE_IDLE;
> +		break;
> +	case STATE_ERROR:
> +		cec_transmit_done(cec->adap, CEC_TX_STATUS_RETRY_TIMEOUT);
> +		cec->tx = STATE_IDLE;

"okay" and "retry_timeout".  So, if we have an adapter which can report
(eg) a NACK, we have to report it as the obscure "retry timeout" status?
Why this obscure naming - why can't we have something that uses the
terminology in the spec?

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
