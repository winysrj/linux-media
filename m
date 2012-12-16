Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:58043 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab2LPWed convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 17:34:33 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 14:34:31 -0800
Subject: RE: [PATCH V3 15/15] [media] marvell-ccic: add 3 frame buffers
 support in DMA_CONTIG mode
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCE7@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-16-git-send-email-twang13@marvell.com>
 <20121216095601.4a086356@hpe.lwn.net>
In-Reply-To: <20121216095601.4a086356@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:56
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 15/15] [media] marvell-ccic: add 3 frame buffers support in
>DMA_CONTIG mode
>
>On Sat, 15 Dec 2012 17:58:04 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> This patch adds support of 3 frame buffers in DMA-contiguous mode.
>>
>> In current DMA_CONTIG mode, only 2 frame buffers can be supported.
>> Actually, Marvell CCIC can support at most 3 frame buffers.
>>
>> Currently 2 frame buffers mode will be used by default.
>> To use 3 frame buffers mode, can do:
>>   define MAX_FRAME_BUFS 3
>> in mcam-core.h
>
>Now that the code supports three buffers properly, is there any reason not
>to use that mode by default?
>
[Albert Wang] Because the original code use the two buffers mode, so we keep it. :)

>Did you test that it works properly if allocation of the third buffer fails?
>
[Albert Wang] Yes, we test it in our Marvell platforms.

>Otherwise looks OK except for one thing:
>
>> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h
>b/drivers/media/platform/marvell-ccic/mcam-core.h
>> index 765d47c..9bf31c8 100755
>> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
>> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
>> @@ -62,6 +62,13 @@ enum mcam_state {
>>  #define MAX_DMA_BUFS 3
>>
>>  /*
>> + * CCIC can support at most 3 frame buffers in DMA_CONTIG buffer mode
>> + * 2 - Use Two Buffers mode
>> + * 3 - Use Three Buffers mode
>> + */
>> +#define MAX_FRAME_BUFS 2 /* Current marvell-ccic used Two Buffers mode */
>> +
>> +/*
>>   * Different platforms work best with different buffer modes, so we
>>   * let the platform pick.
>>   */
>> @@ -99,6 +106,10 @@ struct mcam_frame_state {
>>  	unsigned int frames;
>>  	unsigned int singles;
>>  	unsigned int delivered;
>> +	/*
>> +	 * Only usebufs == 2 can enter single buffer mode
>> +	 */
>> +	unsigned int usebufs;
>>  };
>
>What is the purpose of the "usebufs" field?  The code maintains it in
>various places, but I don't see anywhere that actually uses that value for
>anything.
>
[Albert Wang] Two buffers mode doesn't need it.
But Three buffers mode need it indicates which conditions we need set the single buffer flag.
I used "tribufs" as the name in the previous version, but it looks it's a confused name when we merged
Two buffers mode and Three buffers mode with same code by removing #ifdef based on your comments months ago. :)
So we just changed the name with "usebufs".

>Thanks,
>
>jon


Thanks
Albert Wang
86-21-61092656
