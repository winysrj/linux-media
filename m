Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.meprolight.com ([194.90.149.17]:41474 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752474Ab2B0KoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 05:44:17 -0500
From: Alex Gershgorin <alexg@meprolight.com>
To: 'Sylwester Nawrocki' <snjw23@gmail.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 27 Feb 2012 12:44:08 +0200
Subject: RE: i.mx35 live video
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2C8966B28E@MEP-EXCH.meprolight.com>
In-Reply-To: <4F4AA4CD.2040605@gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
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

<It should work when you request 2 USERPTR buffers and assign same address 
(>frame buffer start) to them. I've seen setups like this working with <videbuf2 based drivers.

Thanks for you information this is what I had in mind :-) 

<However it's really poor configuration, to avoid tearing
<you could just set framebuffer virtual window size to contain at least
<two screen windows and for the second buffer use framebuffer start address
<with a proper offset as the USERPTR address. Then you could just add <display panning to display every frame.  

Looks good I'll try to implement this method.
Thank you for your advice. 

Regards,
Alex Gershgorin



