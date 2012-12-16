Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:53872 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491Ab2LPVy4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 16:54:56 -0500
From: Albert Wang <twang13@marvell.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Sun, 16 Dec 2012 13:54:48 -0800
Subject: RE: [PATCH V3 05/15] [media] marvell-ccic: refine
 mcam_set_contig_buffer function
Message-ID: <477F20668A386D41ADCC57781B1F70430D13C8CCDF@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
	<1355565484-15791-6-git-send-email-twang13@marvell.com>
 <20121216090658.3a75c8fe@hpe.lwn.net>
In-Reply-To: <20121216090658.3a75c8fe@hpe.lwn.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jonathan


>-----Original Message-----
>From: Jonathan Corbet [mailto:corbet@lwn.net]
>Sent: Monday, 17 December, 2012 00:07
>To: Albert Wang
>Cc: g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 05/15] [media] marvell-ccic: refine mcam_set_contig_buffer
>function
>
>On Sat, 15 Dec 2012 17:57:54 +0800
>Albert Wang <twang13@marvell.com> wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch refines mcam_set_contig_buffer() in mcam core
>
>It might be nice if the changelog said *why* this was being done -
[Albert Wang] We just want to reduce some redundancy code. :)

>don't worry about insulting my ugly code :)  But no biggie...
>
>Acked-by: Jonathan Corbet <corbet@lwn.net>
>
>jon



Thanks
Albert Wang
86-21-61092656
