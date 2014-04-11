Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.209]:21510 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbaDKGD1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 02:03:27 -0400
Message-ID: <53478425.1010502@barco.com>
Date: Fri, 11 Apr 2014 07:56:53 +0200
From: Thomas Scheuermann <scheuermann@barco.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: AW: v4l2_buffer with PBO mapped memory
References: <533C2872.5090603@barco.com> <82154683.DEhQIaoLxb@avalon> <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2EA13@KUUMEX11.barco.com> <12148246.7IO9AkCti4@avalon>
In-Reply-To: <12148246.7IO9AkCti4@avalon>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07.04.2014 01:37, Laurent Pinchart wrote:
> Hi Thomas,
>
> On Friday 04 April 2014 20:01:33 Scheuermann, Mail wrote:
>> Hi Laurent,
>>
>> I've done the following:
>>
>> echo 3 >/sys/module/videobuf2_core/parameters/debug
>>
>> and found in /var/log/kern.log after starting my program:
>>
>> [239432.535077] vb2: Buffer 0, plane 0 offset 0x00000000
>> [239432.535080] vb2: Buffer 1, plane 0 offset 0x001c2000
>> [239432.535082] vb2: Buffer 2, plane 0 offset 0x00384000
>> [239432.535083] vb2: Allocated 3 buffers, 1 plane(s) each
>> [239432.535085] vb2: qbuf: userspace address for plane 0 changed,
>> reacquiring memory
>> [239432.535087] vb2: qbuf: failed acquiring userspace memory for plane 0
> This confirms everything is working properly up to the point where videobuf2-
> vmalloc fails to acquire the user pointer memory. The problem comes from
> vb2_vmalloc_get_userptr() in drivers/media/v4l2-core/videobuf2-vmalloc.c.
> Unfortunately that function lacks debugging. Are you familiar enough with
> kernel programming to add printk statements there and see where it fails ?
I was able to put some debug output in vb2_vmalloc_get_userptr.
A call to 'vb2_get_contig_userptr' failed.
I will also put some debug code there to get more information.
>> [239432.535088] vb2: qbuf: buffer preparation failed: -22
>> [239432.535128] vb2: streamoff: not streaming

This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
