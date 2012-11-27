Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54280 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab2K0RZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 12:25:37 -0500
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 27 Nov 2012 09:25:51 -0800
Subject: RE: [PATCH 0/15] [media] marvell-ccic: add soc camera support on
 marvell-ccic
Message-ID: <477F20668A386D41ADCC57781B1F70430D1367C92A@SC-VEXCH1.marvell.com>
References: <1353677450-23876-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1211271813350.22273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211271813350.22273@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Geunnadi

Thank you very much for your review!

Your help is very valuable for us.

We will work out the next version based on your suggestion!

I hope to get back to you on the review of the version 3 patch series next week. :)

Have a nice day!


Thanks
Albert Wang
86-21-61092656


>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, 28 November, 2012 01:16
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH 0/15] [media] marvell-ccic: add soc camera support on marvell-ccic
>
>Hi Laxman
>
>Just a general comment: this patch series is a huge improvement over the previous
>versions, now it is actually already reviewable! :-) Thanks for keeping on with this work!
>
>Best regards
>Guennadi
>
>On Fri, 23 Nov 2012, Albert Wang wrote:
>
>> The following patches series will add soc camera support on
>> marvell-ccic
>>
>> Change log v2:
>> 	- remove register definition patch
>> 	- split big patch to some small patches
>> 	- split mcam-core.c to mcam-core.c and mcam-core-standard.c
>> 	- add mcam-core-soc.c for soc camera support
>> 	- split 3 frame buffers support patch into 2 patches
>>
>> [PATCH 01/15] [media] marvell-ccic: use internal variable replace
>> [PATCH 02/15] [media] marvell-ccic: add MIPI support for marvell-ccic
>> driver [PATCH 03/15] [media] marvell-ccic: add clock tree support for
>> marvell-ccic driver [PATCH 04/15] [media] marvell-ccic: reset ccic phy
>> when stop streaming for stability [PATCH 05/15] [media] marvell-ccic:
>> refine mcam_set_contig_buffer function [PATCH 06/15] [media]
>> marvell-ccic: add new formats support for marvell-ccic driver [PATCH
>> 07/15] [media] marvell-ccic: add SOF / EOF pair check for marvell-ccic
>> driver [PATCH 08/15] [media] marvell-ccic: switch to resource managed
>> allocation and request [PATCH 09/15] [media] marvell-ccic: refine
>> vb2_ops for marvell-ccic driver [PATCH 10/15] [media] marvell-ccic:
>> split mcam core into 2 parts for soc_camera support [PATCH 11/15]
>> [media] marvell-ccic: add soc_camera support in mcam core [PATCH
>> 12/15] [media] marvell-ccic: add soc_camera support in mmp driver
>> [PATCH 13/15] [media] marvell-ccic: add dma burst mode support in
>> marvell-ccic driver [PATCH 14/15] [media] marvell-ccic: use unsigned
>> int type replace int type [PATCH 15/15] [media] marvell-ccic: add 3
>> frame buffers support in DMA_CONTIG mode
>>
>>
>> v1:
>> [PATCH 1/4] [media] mmp: add register definition for marvell ccic
>> [PATCH 2/4] [media] marvell-ccic: core: add soc camera support on
>> marvell-ccic mcam-core [PATCH 3/4] [media] marvell-ccic: mmp: add soc
>> camera support on marvell-ccic mmp-driver [PATCH 4/4] [media]
>> marvell-ccic: core: add 3 frame buffers support in DMA_CONTIG mode
>>
>>
>> Thanks
>> Albert Wang
>>
>
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer http://www.open-technology.de/
