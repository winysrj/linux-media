Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.112]:5997 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbaDDUBj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Apr 2014 16:01:39 -0400
From: "Scheuermann, Mail" <Scheuermann@barco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: AW: AW: v4l2_buffer with PBO mapped memory
Date: Fri, 4 Apr 2014 20:01:33 +0000
Message-ID: <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2EA13@KUUMEX11.barco.com>
References: <533C2872.5090603@barco.com> <11263729.kS3FzW2BUL@avalon>
 <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2C949@KUUMEX11.barco.com>,<82154683.DEhQIaoLxb@avalon>
In-Reply-To: <82154683.DEhQIaoLxb@avalon>
Content-Language: de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I've done the following:

echo 3 >/sys/module/videobuf2_core/parameters/debug

and found in /var/log/kern.log after starting my program:

Apr  4 21:53:48 x240 kernel: [239432.535077] vb2: Buffer 0, plane 0 offset 0x00000000
Apr  4 21:53:48 x240 kernel: [239432.535080] vb2: Buffer 1, plane 0 offset 0x001c2000
Apr  4 21:53:48 x240 kernel: [239432.535082] vb2: Buffer 2, plane 0 offset 0x00384000
Apr  4 21:53:48 x240 kernel: [239432.535083] vb2: Allocated 3 buffers, 1 plane(s) each
Apr  4 21:53:48 x240 kernel: [239432.535085] vb2: qbuf: userspace address for plane 0 changed, reacquiring memory
Apr  4 21:53:48 x240 kernel: [239432.535087] vb2: qbuf: failed acquiring userspace memory for plane 0
Apr  4 21:53:48 x240 kernel: [239432.535088] vb2: qbuf: buffer preparation failed: -22
Apr  4 21:53:48 x240 kernel: [239432.535128] vb2: streamoff: not streaming

Regards,

Thomas

________________________________________
Von: Laurent Pinchart [laurent.pinchart@ideasonboard.com]
Gesendet: Freitag, 4. April 2014 01:16
An: Scheuermann, Mail
Cc: linux-media@vger.kernel.org
Betreff: Re: AW: v4l2_buffer with PBO mapped memory

Hi Thomas,

On Thursday 03 April 2014 16:52:19 Scheuermann, Mail wrote:
> Hi Laurent,
>
> the driver my device uses is the uvcvideo. I have the kernel 3.11.0-18 from
> Ubuntu 13.10 running. It is built in in a Thinkpad X240 notebook.

OK. A bit of debugging will then be needed. Could you set the videobuf2-core
debug parameter to 3, retry your test case and send us the kernel log ?

--
Regards,

Laurent Pinchart

This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
