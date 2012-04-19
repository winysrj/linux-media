Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43066 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756834Ab2DSWxM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 18:53:12 -0400
Subject: Re: v4l-cx23885-enc.fw
From: Andy Walls <awalls@md.metrocast.net>
To: Britney Fransen <britney.fransen@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 19 Apr 2012 18:53:09 -0400
In-Reply-To: <59883F72-DC46-4AB7-9271-C0A844A7D45F@gmail.com>
References: <59883F72-DC46-4AB7-9271-C0A844A7D45F@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1334875990.14608.16.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-04-17 at 16:18 -0500, Britney Fransen wrote:
> I am not sure where to report this so if this is the wrong place and
> someone can point me in the right direction it would be appreciated.
> 
> http://www.linuxtv.org/downloads/firmware/v4l-cx23885-enc.fw &
> http://www.linuxtv.org/downloads/firmware/v4l-cx23885-avcore-01.fw
> look to be the same file with different names.

Well, that's not good.  They should be very different.

The "avcore" firmware is for the analog TV audio broadcast standard
auto-detection.  It is used by the "Merlin" audio core in the integrated
CX25843 core inside the CX2388[578] chip.

The "enc" firmware is for a CX2341[67] MPEG-2 encoder chip connected to
the CX2388[578] chip.

>   However when I extract the firmware from
> http://steventoth.net/linux/hvr1800/ v4l-cx23885-enc.fw is
> significantly larger than v4l-cx23885-avcore-01.fw.  When using
> http://www.linuxtv.org/downloads/firmware/v4l-cx23885-enc.fw I get
> cx23885_initialize_codec() f/w load failed.  Using the larger
> v4l-cx23885-enc.fw from http://steventoth.net/linux/hvr1800/ the
> firmware loads without error.  I believe that the
> http://www.linuxtv.org/downloads/firmware/v4l-cx23885-enc.fw is
> incorrect.
> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=tree also has the same incorrect v4l-cx23885-enc.fw file.

I believe you are correct.

Regards,
Andy


> Thanks,
> Britney--


