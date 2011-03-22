Return-path: <mchehab@pedra>
Received: from smtpauth03.prod.mesa1.secureserver.net ([64.202.165.183]:54327
	"HELO smtpauth03.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751856Ab1CVJSY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 05:18:24 -0400
Subject: Re: soc-camera layer2 driver
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Gilles <gilles@gigadevices.com>
In-Reply-To: <Pine.LNX.4.64.1103210854040.21013@axis700.grange>
Date: Tue, 22 Mar 2011 02:18:22 -0700
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <4898622A-5298-4E4D-BAB0-D1C71B7C2845@gigadevices.com>
References: <092708F1-CB5B-420A-B675-EED63B7E68A7@gigadevices.com> <Pine.LNX.4.64.1103210854040.21013@axis700.grange>
To: linux-media@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear Dr Guennadi,

Thank you for your answer.


> 1. soc-camera core
> 2. camera host driver (receive from sensor, DMA to RAM)
> 3. camera sensor drivers
> 
> If you're developing new hardware, you'll have to write new layer 2 driver 
> for it.

I do understand that part, I guess what I was asking was for any pointers to some up-to-date guides on how to do this. I couldn't find a good documentation on how to to that. I must add that even though I have written drivers to other operating systems, I am new at writing drivers for Linux. The V4L2 layer appears very powerful and, at the same time, there is a lot of documentation out there but, a lot also appears to be obsolete. Of course, the best way is to modify something current. I will attempt to do this but I would still appreciate any current howtos you could point me to.


> As for stereo vision: since you're going to use the same sensor, you will 
> either have to put it on a different i2c bus, or wire it to configure a 
> different i2c address. In either case communicating to it shouldn't be a 
> problem.


Yes, of course and I can change the I2C address so I can use the same bus. My question was more related to synchronization of both frames. Initially, I thought about multiplexing the cameras at the hardware level so that every frame, the data bus would switch to the other camera but then, one has not control over the camera horizontal sync signals. There is no way to guarantee that both cameras HSync are ... well synchronized. Then of course, the other problem would be that the frames would be out of sync in terms of time of capture.

Anyway, the question was more related to synchronicity. And I guess the answer would depend on whether I wanted to capture frame-alternative 3D or side-by-side 3D. Maybe this is too new, I just can't find detailed information about 3D in V4L2.

I appreciate any up-to-date documents you can point me to.

Cheers,
Gilles
.


On Mar 21, 2011, at 01:02 , Guennadi Liakhovetski wrote:

> Hi Gilles
> 
> On Mon, 21 Mar 2011, Gilles wrote:
> 
>> Hi,
>> 
>> I am sorry to bother you but after hours of searching google without 
>> luck I thought I'd ask you what might take you 5 minutes to answer if 
>> you please would.
>> 
>> I have developed a custom hardware which can host one or two cameras and 
>> I am a little confused (mainly because I can't seem to find up-to-date 
>> documentation on how to do it) as to:
> 
> All (non-commercial) requests should really be discussed on the
> 
> Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> mailing list. Please, repost your query to the list with my email in CC.
> 
> In short, if I understood you right, you are developing new hardware, that 
> receives data from video sensors and DMAs it into RAM, correct? In general 
> the soc-camera stack consists of 3 layers:
> 
> 1. soc-camera core
> 2. camera host driver (receive from sensor, DMA to RAM)
> 3. camera sensor drivers
> 
> If you're developing new hardware, you'll have to write new layer 2 driver 
> for it.
> 
> As for stereo vision: since you're going to use the same sensor, you will 
> either have to put it on a different i2c bus, or wire it to configure a 
> different i2c address. In either case communicating to it shouldn't be a 
> problem.
> 
> We can further discuss details on the mailing list.
> 
> Thanks
> Guennadi
> 
>> - Which files do I need to modify so that soc-camera "knows" where/how 
>> to access the hardware pins where the camera is connected to.
>> 
>> - I'm not sure I understand how the H/V sync works. My camera is 
>> connected to a parallel interface which is designed to do DMA into 
>> memory (clocked by the camera pixel clock). Don't the H/V signals need 
>> to generate an interrupt to reset the DMA addresses? It appears as the 
>> soc infrastructure does not require that but I don't understand how the 
>> drivers know that a new frame is available?
>> 
>> - Curently, the hardware I designed is designed to handle one camera at 
>> once but I have been asked if it would be possible to modify the 
>> hardware to run both cameras at once (which I can easily do). How would 
>> you recommend implementing stereo-vision? If both cameras are of the 
>> same kind (same driver), I am also a little confused how the same soc 
>> driver would know which one of the two hardwares it needs to bind to.
>> 
>> If you could just point me to *any* documentation that would explain 
>> (something up-to-date) how to adapt linux to match my hardware, I would 
>> GREATLY appreciate it as I am a bit lost.
>> 
>> Thank you,
>> Gilles
>> .
>> 
>> 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

