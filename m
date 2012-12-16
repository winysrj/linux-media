Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:43874 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab2LPWet convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 17:34:49 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 14:34:46 -0800
Subject: RE: [PATCH V3 00/15] [media] marvell-ccic: add soc camera support
 on marvell-ccic
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCE8@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <20121216095737.12c52c00@hpe.lwn.net>
In-Reply-To: <20121216095737.12c52c00@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan

Thank you very much for taking your weekend time to review our patches! :)


Thanks
Albert Wang
86-21-61092656

>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:58
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org
>Subject: Re: [PATCH V3 00/15] [media] marvell-ccic: add soc camera support on marvell-
>ccic
>
>On Sat, 15 Dec 2012 17:57:49 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> The following patches series will add soc_camera support on marvell-ccic
>
>Overall, this patch set has come a long way - great work!
>
>As I commented on the specific patches, I still have some concerns
>about the soc_camera part of it.  There's various quibbles with the
>rest, but mostly not much that's serious.  I think this work is getting
>close to being ready.
>
>Thanks,
>
>jon
>
>
>Jonathan Corbet / LWN.net / corbet@lwn.net
