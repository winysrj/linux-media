Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:34007 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771Ab2K0LDf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 06:03:35 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 03:02:23 -0800
Subject: RE: [PATCH 01/15] [media] marvell-ccic: use internal variable
 replace global frame stats variable
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C8CD@SC-VEXCH1.marvell.com>
References: <1353677577-23962-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271110530.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271110530.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Nice to hear you again after holidays. :)

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Tuesday, 27 November, 2012 18:16
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 01/15] [media] marvell-ccic: use internal variable replace global frame
>stats variable
>
>Hi Albert
>
>On Fri, 23 Nov 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch replaces the global frame stats variables by using internal
>> variables in mcam_camera structure.
>>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>
>Thanks for doing this work! Looks good just one remark below.
>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.c |   30 ++++++++++-------------
>>  drivers/media/platform/marvell-ccic/mcam-core.h |    9 +++++++
>>  2 files changed, 22 insertions(+), 17 deletions(-)
>
>[snip]
>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>> b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index bd6acba..e226de4 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -73,6 +73,14 @@ static inline int mcam_buffer_mode_supported(enum
>mcam_buffer_mode mode)
>>  	}
>>  }
>>
>> +/*
>> + * Basic frame states
>> + */
>> +struct mmp_frame_state {
>
>I think this should be "struct mcam_frame_state" - don't think we need to introduce a whole
>new namespace in this header just because of this struct.
>
Yes, you are right. We should keep same namespace in this header.
Maybe we did a typo.

>> +	unsigned int frames;
>> +	unsigned int singles;
>> +	unsigned int delivered;
>> +};
>>
>>  /*
>>   * A description of one of our devices.
>> @@ -108,6 +116,7 @@ struct mcam_camera {
>>  	unsigned long flags;		/* Buffer status, mainly (dev_lock) */
>>  	int users;			/* How many open FDs */
>>
>> +	struct mmp_frame_state frame_state;	/* Frame state counter */
>>  	/*
>>  	 * Subsystem structures.
>>  	 */
>> --
>> 1.7.9.5
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer http://www.open-technology.de/
