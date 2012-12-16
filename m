Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:47338 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab2LPWAz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 17:00:55 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 14:00:54 -0800
Subject: RE: [PATCH V3 07/15] [media] marvell-ccic: add SOF / EOF pair check
 for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCE1@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-8-git-send-email-twang13@marvell.com>
 <20121216091915.08c4ba80@hpe.lwn.net>
In-Reply-To: <20121216091915.08c4ba80@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:19
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 07/15] [media] marvell-ccic: add SOF / EOF pair check for
>marvell-ccic driver
>
>On Sat, 15 Dec 2012 17:57:56 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the SOFx/EOFx pair check for marvell-ccic.
>>
>> When switching format, the last EOF may not arrive when stop streamning.
>> And the EOF will be detected in the next start streaming.
>>
>> Must ensure clear the obsolete frame flags before every really start streaming.
>
>"obsolete" doesn't quite read right; it suggests that the flags only
>apply to older hardware.  I'd suggest "left over" or some such (in the
>code comment too).  Otherwise seems fine.
>
[Albert Wang] OK, we will change the "bad" word. :)

>Acked-by: Jonathan Corbet <corbet@lwn.net>
>
>jon


Thanks
Albert Wang
86-21-61092656
