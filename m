Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65376 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2BZVcB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 16:32:01 -0500
Received: by eaah12 with SMTP id h12so1943243eaa.19
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2012 13:31:59 -0800 (PST)
Message-ID: <4F4AA4CD.2040605@gmail.com>
Date: Sun, 26 Feb 2012 22:31:57 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Alex Gershgorin <alexg@meprolight.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: i.mx35 live video
References: <4875438356E7CA4A8F2145FCD3E61C0B2C8966B28A@MEP-EXCH.meprolight.com> <Pine.LNX.4.64.1202262154550.17982@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1202262154550.17982@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/26/2012 09:58 PM, Guennadi Liakhovetski wrote:
>>> It might be difficult to completely eliminate the CPU, at the very least
>>> you need to queue and dequeue buffers to and from the V4L driver. To avoid
>>> even that, in principle, you could try to use only one buffer, but I don't
>>> think the current version of the mx3_camera driver would be very happy
>>> about that. You could take 2 buffers and use panning, then you'd just have
>>> to send queue and dequeue buffers and pan the display. But in any case,
>>> you probably will have to process buffers, but your most important
>>> advantage is, that you won't have to copy data, you only have to move
>>> pointers around.
>>
>> The method that you describe is exactly what I had in mind.
>> It would be more correct to say it is "minimum" CPU intervention and not without CPU intervention.
> 
>> As far I understand, I can implement MMAP method for frame buffer device
>> and pass this pointer directly to mx3_camera driver with use USERPTR
>> method, then send queue and dequeue buffers to mx3_camera driver.
>> What is not clear, if it is possible to pass the same pointer of frame
>> buffer in mx3_camera, if the driver is using two buffers?

It should work when you request 2 USERPTR buffers and assign same address 
(frame buffer start) to them. I've seen setups like this working with videbuf2
based drivers. However it's really poor configuration, to avoid tearing
you could just set framebuffer virtual window size to contain at least
two screen windows and for the second buffer use framebuffer start address
with a proper offset as the USERPTR address. Then you could just add display
panning to display every frame.  

--

Regards,
Sylwester

> Sorry, I really don't know for sure. It should work, but I don't think I
> tested thid myself nor I remember anybody reporting having tested this
> mode. So, you can either try to search mailing list archives, or just test
> it. Begin with a simpler mode - USERPTR with separately allocated buffers
> and copying them manually to the framebuffer, then try to switch to just
> one buffer in this same mode, then switch to direct framebuffer memory.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

