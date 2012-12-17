Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:51703 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711Ab2LQFGN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 00:06:13 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 21:06:00 -0800
Subject: RE: [PATCH V3 15/15] [media] marvell-ccic: add 3 frame buffers
 support in DMA_CONTIG mode
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CD48@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-16-git-send-email-twang13@marvell.com>
	<20121216095601.4a086356@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE7@SC-VEXCH1.marvell.com>
 <20121216155503.2ce60997@lwn.net>
In-Reply-To: <20121216155503.2ce60997@lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 06:55
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 15/15] [media] marvell-ccic: add 3 frame buffers support in
>DMA_CONTIG mode
>
>On Sun, 16 Dec 2012 14:34:31 -0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> >What is the purpose of the "usebufs" field?  The code maintains it in
>> >various places, but I don't see anywhere that actually uses that value for
>> >anything.
>> >
>> [Albert Wang] Two buffers mode doesn't need it.
>> But Three buffers mode need it indicates which conditions we need set the single
>buffer flag.
>> I used "tribufs" as the name in the previous version, but it looks it's a confused name
>when we merged
>> Two buffers mode and Three buffers mode with same code by removing #ifdef based
>on your comments months ago. :)
>> So we just changed the name with "usebufs".
>
>OK, I misread the code a bit, sorry.  I do find the variable confusing
>still, but it clearly does play a role.
>
>I think that using three buffers by default would make sense.  I don't
>think that increased overruns are an unbreakable ABI feature :)
>
[Albert Wang] OK, we can change the default to three buffers mode.

>Feel free to add my ack to this one.
>
>Thanks,
>
>jon


Thanks
Albert Wang
86-21-61092656
