Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43793 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab1ARJgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 04:36:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enric =?utf-8?q?Balletb=C3=B2_i_Serra?= <eballetbo@gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
Date: Tue, 18 Jan 2011 10:36:35 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com> <201101141801.01125.laurent.pinchart@ideasonboard.com> <AANLkTi=ipwaYj=Be+fqAKhKbaMdR-u8cEquUwapuHYcs@mail.gmail.com>
In-Reply-To: <AANLkTi=ipwaYj=Be+fqAKhKbaMdR-u8cEquUwapuHYcs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101181036.35818.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Enric,

On Tuesday 18 January 2011 10:20:43 Enric Balletbò i Serra wrote:
> 
> Now seems yavta is blocked dequeuing a buffer ( VIDIOC_DQBUF ), with
> strace I get
> 
> $ strace ./yavta -f SGRBG10 -s 720x525 -n 1 --capture=1 -F /dev/video2
> 
> mmap2(NULL, 756000, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0x4011f000
> write(1, "Buffer 0 mapped at address 0x401"..., 39Buffer 0 mapped at
> address 0x4011f000.
> ) = 39
> ioctl(3, VIDIOC_QBUF or VT_SETACTIVATE, 0xbede36cc) = 0
> ioctl(3, VIDIOC_STREAMON, 0xbede365c)   = 0
> gettimeofday({10879, 920196}, NULL)     = 0
> ioctl(3, VIDIOC_DQBUF
> 
> and the code where stops is here
> 
> ispqueue.c
> 913	buf = list_first_entry(&queue->queue, struct isp_video_buffer, stream);
> 914	ret = isp_video_buffer_wait(buf, nonblocking);
> 
> Any idea ?

My guess is that the CCDC doesn't receive the amount of lines it expects.

The CCDC generates an interrupt at 2/3 of the image and another one at the 
beginning of the last line. Start by checking if the ISP generates any 
interrupt to the host with cat /proc/interrupts. If it doesn't, then the CCDC 
receives less than 2/3 of the expected number of lines. If it does, it 
probably receives between 2/3 and 3/3. You can add printk statements in 
ispccdc_vd0_isr() and ispccdc_vd1_isr() to confirm this.

-- 
Regards,

Laurent Pinchart
