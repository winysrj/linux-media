Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33356 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbbJMX0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2015 19:26:35 -0400
Date: Wed, 14 Oct 2015 00:26:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kamil Debski <kamil@wypas.org>, Hans Verkuil <hansverk@cisco.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, sean@mess.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv9 14/15] cec: s5p-cec: Add s5p-cec driver
Message-ID: <20151013232624.GO32532@n2100.arm.linux.org.uk>
References: <cover.1441633456.git.hansverk@cisco.com>
 <b55a5c1ff9318211aa472b28d03a978aad23770b.1441633456.git.hansverk@cisco.com>
 <20151005223207.GM21513@n2100.arm.linux.org.uk>
 <561B906F.9020508@xs4all.nl>
 <CAP3TMiFj47GMYEqnNTXQv3vKbwnDGKhRDcMrwTY42RVUH-_d4Q@mail.gmail.com>
 <561BAA0E.4040905@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561BAA0E.4040905@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:39:42PM +0200, Hans Verkuil wrote:
> On 10/12/2015 02:33 PM, Kamil Debski wrote:
> > The possible status values that are implemented in the CEC framework
> > are following:
> > 
> > +/* cec status field */
> > +#define CEC_TX_STATUS_OK               (0)
> > +#define CEC_TX_STATUS_ARB_LOST         (1 << 0)
> > +#define CEC_TX_STATUS_RETRY_TIMEOUT    (1 << 1)
> > +#define CEC_TX_STATUS_FEATURE_ABORT    (1 << 2)
> > +#define CEC_TX_STATUS_REPLY_TIMEOUT    (1 << 3)
> > +#define CEC_RX_STATUS_READY            (0)
> > 
> > The only two ones I could match with the Exynos CEC module status bits are
> > CEC_TX_STATUS_OK and  CEC_TX_STATUS_RETRY_TIMEOUT.
> > 
> > The status bits in Exynos HW are:
> > - Tx_Error
> > - Tx_Done
> > - Tx_Transferring
> > - Tx_Running
> > - Tx_Bytes_Transferred
> > 
> > - Tx_Wait
> > - Tx_Sending_Status_Bit
> > - Tx_Sending_Hdr_Blk
> > - Tx_Sending_Data_Blk
> > - Tx_Latest_Initiator
> > 
> > - Tx_Wait_SFT_Succ
> > - Tx_Wait_SFT_New
> > - Tx_Wait_SFT_Retran
> > - Tx_Retrans_Cnt
> > - Tx_ACK_Failed
> 
> So are these all intermediate states? And every transfer always ends with Tx_Done or
> Tx_Error state?
> 
> It does look that way...

For the Synopsis DW CEC, I have:

Bit Field	Description
4   ERROR_INIT	An error is detected on cec line (for initiator only).
3   ARB_LOST	The initiator losses the CEC line arbitration to a second
		initiator. (specification CEC 9).
2   NACK	A frame is not acknowledged in a directly addressed message.
		Or a frame is negatively acknowledged in a broadcast message
		(for initiator only).
0   DONE	The current transmission is successful (for initiator only).

That's about as much of a description that there is for this hardware.
Quite what comprises an "ERROR_INIT", I don't know.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
