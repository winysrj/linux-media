Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:36678 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab2JEN4b convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Oct 2012 09:56:31 -0400
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Fri, 5 Oct 2012 06:18:46 -0700
Subject: RE: [PATCH 4/4] [media] marvell-ccic: core: add 3 frame buffers
 support in DMA_CONTIG mode
Message-ID: <477F20668A386D41ADCC57781B1F7043083B6575C2@SC-VEXCH1.marvell.com>
References: <1348840059-21456-1-git-send-email-twang13@marvell.com>
 <20120929135120.0567e609@hpe.lwn.net>
In-Reply-To: <20120929135120.0567e609@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Sunday, 30 September, 2012 03:51
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org
>Subject: Re: [PATCH 4/4] [media] marvell-ccic: core: add 3 frame buffers support in
>DMA_CONTIG mode
>
>On Fri, 28 Sep 2012 21:47:39 +0800
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
>I have no problem with the concept.  I honestly don't remember why I only used the two-
>buffer mode for dma-contig; perhaps it's because getting even two buffers can be a bit
>of a challenge on a lot of systems, maybe.  The application really needs to be able to
>get at least four buffers for the three-buffer mode to be worthwhile (otherwise you're
>always in a situation where the driver owns less than three and has to juggle things).  But
>we can certainly add it.
>
Thank you for your review!
Sorry for late response.

>I wish this were two patches, though:
>	1) Change lots of int variables to unsigned int (with reasoning
>	   as to why we want to do that).
>	2) Add three-buffer mode.
>
OK. Your suggestion is reasonable.
We can do that in Version 2 of patches.

>The mode should be runtime-selectable, as it is with the vmalloc mode.
>
>Otherwise seems OK.
>
>Thanks,
>
>jon

Thanks
Albert Wang
86-21-61092656
