Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:1518 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab0EZOxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 10:53:05 -0400
Message-ID: <4BFD1C5F.5060403@atmel.com>
Date: Wed, 26 May 2010 15:04:31 +0200
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-input@vger.kernel.org
Subject: Re: ATMEL camera interface
References: <4BD9AA8A.7030306@atmel.com> <Pine.LNX.4.64.1004291824200.4666@axis700.grange> <4BDED3A8.4090606@atmel.com> <Pine.LNX.4.64.1005031556570.4231@axis700.grange> <4BDEDB06.9090909@atmel.com> <Pine.LNX.4.64.1005031622040.4231@axis700.grange> <4BDEEE38.9070801@atmel.com> <Pine.LNX.4.64.1005031836140.4231@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1005031836140.4231@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

So I have decided to go with the v4l2-subdev API.
I have taken the omapxxcam and vivi.c as exemple, but I have some 
questions...
I still don't understand how to register a v4l2 device. I tried to copy 
the method from vivi.c using v4l2_device_register but it is not working?
If I just use video_regiter_device, then it is trying to use the default 
ioctl and open/close functions from v4l2(v4l2_open) instead of the one I 
hae in my driver...
What am I doing wrong?

BR,
Sedji

Le 5/3/2010 6:40 PM, Guennadi Liakhovetski a écrit :
> On Mon, 3 May 2010, Sedji Gaouaou wrote:
>
>> Well sorry to bother you again but I am looking at the mx1_camera.c file, and
>> I wonder where are implemented the queue and dqueue functions?
>>
>> The atmel IP is using linked list for the buffers, and previously I was
>> managing it in the queue and dqueue functions.
>> I am not sure where I should take care of it now?
>
> qbuf and dqbuf are implemented by soc-camera in soc_camera_qbuf() and
> soc_camera_dqbuf() respectively, drivers only implement methods from
> struct videobuf_queue_ops, e.g., a .buf_queue method, which for mx1_camera
> is implemented by mx1_videobuf_queue().
>
> Thanks
> Guennadi
>
>>
>>
>> Regards,
>> Sedji
>>
>> Le 5/3/2010 4:26 PM, Guennadi Liakhovetski a écrit :
>>> On Mon, 3 May 2010, Sedji Gaouaou wrote:
>>>
>>>> Well I need contiguous memory, so I guess I will have a look at
>>>> mx1_camera.c?
>>>> Is there another example?
>>>>
>>>> What do you mean by videobuf implementation? As I said I just need a
>>>> contiguous memory.
>>>
>>> I mean, whether you're gping to use videobuf-dma-contig.c or
>>> videobuf-dma-sg.c, respectively, whether you'll be calling
>>> videobuf_queue_dma_contig_init() or videobuf_queue_sg_init() in your
>>> driver.
>>>
>>> Regards
>>> Guennadi
>>> ---
>>> Guennadi Liakhovetski, Ph.D.
>>> Freelance Open-Source Software Developer
>>> http://www.open-technology.de/
>>>
>>
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>


