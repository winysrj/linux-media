Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:39683 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab2LPWMM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 17:12:12 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 14:12:11 -0800
Subject: RE: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
 <20121216093717.4be8feff@hpe.lwn.net>
In-Reply-To: <20121216093717.4be8feff@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:37
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2 parts for
>soc_camera support
>
>On Sat, 15 Dec 2012 17:57:59 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> This patch splits mcam-core into 2 parts to prepare for soc_camera support.
>>
>> The first part remains in mcam-core.c. This part includes the HW operations
>> and vb2 callback functions.
>>
>> The second part is moved to mcam-core-standard.c. This part is relevant with
>> the implementation of using V4L2.
>
>OK, I'll confess I'm still not 100% sold on this part.  Can I repeat
>the questions I raised before?
>
> - Is the soc_camera mode necessary?  Is there something you're trying
>   to do that can't be done without it?  Or, at least, does it add
>   sufficient benefit to be worth this work?  It would be nice if the
>   reasoning behind this change were put into the changelog.
>
[Albert Wang] We just want to add one more option for user. :)
And we split it to 2 parts because we want to keep the original mode.

> - If the soc_camera change is deemed to be worthwhile, is there
>   anything preventing you from doing it 100% so it's the only mode
>   used?
>
[Albert Wang] No, but current all Marvell platform have used the soc_camera in camera driver. :)
So we just hope the marvell-ccic can have this option. :)

>The split as you've done it here is an improvement over what came
>before, but it still results in a lot of duplicated code; it also adds
>a *lot* of symbols to the global namespace.  If this is really the only
>way then we'll find a way to make it work, but I'd like to be sure that
>we can't do something better.
>
>Thanks,
>
>jon



Thanks
Albert Wang
86-21-61092656
