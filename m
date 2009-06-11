Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:56508 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbZFKPAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 11:00:14 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 11 Jun 2009 10:00:05 -0500
Subject: RE: mt9t031 (was RE: [PATCH] adding support for setting bus
 parameters in sub device)
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A09039@dlee06.ent.ti.com>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906102022320.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08DC3@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906102303190.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08E4F@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906102337130.4817@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40139A08E67@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0906110112590.4817@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906110112590.4817@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>On Wed, 10 Jun 2009, Karicheri, Muralidharan wrote:
>
>> So how do I know what frame-rate I get? Sensor output frame rate depends
>> on the resolution of the frame, blanking, exposure time etc.
>
>This is not supported.
>
I am still not clear. You had said in an earlier email that it can support streaming. That means application can stream frames from the capture device.
I know you don't have support for setting a specific frame rate, but it must be outputting frame at some rate right?

Here is my usecase.

open capture device,
set resolutions (say VGA) for capture (S_FMT ???)
request buffer for streaming & mmap & QUERYBUF
start streaming (STREAMON)
DQBUF/QBUF in a loop -> get VGA buffers at some fps.
STREAMOFF
close device

Is this possible with mt9t031 available currently in the tree? This requires sensor device output frames continuously on the bus using PCLK/HSYNC/VSYNC timing to the bridge device connected to the bus. Can you give a use case like above that you are using. I just want to estimate how much effort is required to add this support in the mt9t031 driver.

Thanks

Murali

>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

