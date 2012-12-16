Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49790 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab2LPV6G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 16:58:06 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 13:58:03 -0800
Subject: RE: [PATCH V3 06/15] [media] marvell-ccic: add new formats support
 for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCE0@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-7-git-send-email-twang13@marvell.com>
 <20121216091633.1b9c1799@hpe.lwn.net>
In-Reply-To: <20121216091633.1b9c1799@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan



>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:17
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 06/15] [media] marvell-ccic: add new formats support for
>marvell-ccic driver
>
>On Sat, 15 Dec 2012 17:57:55 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the new formats support for marvell-ccic.
>
>Once again, just one second-order comment:
>
>> +static bool mcam_fmt_is_planar(__u32 pfmt)
>> +{
>> +	switch (pfmt) {
>> +	case V4L2_PIX_FMT_YUV422P:
>> +	case V4L2_PIX_FMT_YUV420:
>> +	case V4L2_PIX_FMT_YVU420:
>> +		return true;
>> +	}
>> +	return false;
>> +}
>
>This seems like the kind of thing that would be useful in a number of
>places; I'd be tempted to push it up a level and make it available to all
>V4L2 drivers.  Of course, that means making it work for *all* formats,
>which would be a pain.
>
>But, then, I can see some potential future pain if somebody adds a new
>format and forgets to tweak this function here.  Rather than adding a new
>switch, could you put a "planar" flag into struct mcam_format_struct
>instead?  That would help to keep all this information together.
>
[Albert Wang] Yes, it looks make sense, we will think about it in next version.

>jon


Thanks
Albert Wang
86-21-61092656
