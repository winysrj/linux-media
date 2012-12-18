Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:40417 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754556Ab2LRUsJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 15:48:09 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Tue, 18 Dec 2012 12:48:03 -0800
Subject: RE: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2
 parts for soc_camera support
Message-ID: <477F20668A386D41ADCC57781B1F70430D13D7FEA4@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-11-git-send-email-twang13@marvell.com>
	<20121216093717.4be8feff@hpe.lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8CCE4@SC-VEXCH1.marvell.com>
	<20121217082832.7f363d05@lwn.net>
	<477F20668A386D41ADCC57781B1F70430D13C8D0E3@SC-VEXCH1.marvell.com>
 <20121218121508.7a4de314@lwn.net>
In-Reply-To: <20121218121508.7a4de314@lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Wednesday, 19 December, 2012 03:15
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 10/15] [media] marvell-ccic: split mcam-core into 2 parts for
>soc_camera support
>
>On Mon, 17 Dec 2012 19:04:26 -0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> [Albert Wang] So if we add B_DMA_SG and B_VMALLOC support and OLPC XO 1.0
>support in soc_camera mode.
>> Then we can just remove the original mode and only support soc_camera mode in
>marvell-ccic?
>
>That is the idea, yes.  Unless there is some real value to supporting both
>modes (that I've not seen), I think it's far better to support just one of
>them.  Trying to support duplicated modes just leads to pain in the long
>run, in my experience.
>
[Albert Wang] OK, we will update and submit the remained patches except for the 3 patches related with soc_camera support as the first part.
Then we will submit the soc_camera support patches after we rework the patches and add B_DMA_SG and B_VMALLOC support and OLPC XO 1.0 support.

>I can offer to *try* to find time to help with XO 1.0 testing when the
>time comes.
>
[Albert Wang] Thank you very much! We were worried about how to get the OLPC XO 1.0 HW. That would be a great help! :)

>Thanks,
>
>jon


Thanks
Albert Wang
86-21-61092656
