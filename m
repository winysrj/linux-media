Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50519 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751304AbeCTH1s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 03:27:48 -0400
Subject: Re: [PATCH v2 1/3] staging: xm2mvscale: Driver support for Xilinx M2M
 Video Scaler
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Rohit Athavale <RATHAVAL@xilinx.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
 <1519252996-787-2-git-send-email-rohit.athavale@xilinx.com>
 <20180222134658.GB19182@kroah.com>
 <1315ef81-15f1-5bc9-eff9-aaa12e70738a@xs4all.nl>
 <BY1PR02MB121105ECDEE95BB9444A65AFA2AB0@BY1PR02MB1211.namprd02.prod.outlook.com>
 <1521510079.2912.18.camel@ndufresne.ca>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9009fc75-1f1e-4332-271a-0b4cf1cb296b@xs4all.nl>
Date: Tue, 20 Mar 2018 08:27:42 +0100
MIME-Version: 1.0
In-Reply-To: <1521510079.2912.18.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/20/2018 02:41 AM, Nicolas Dufresne wrote:
> Le mardi 20 mars 2018 à 00:46 +0000, Rohit Athavale a écrit :
>> Hi Hans,
>>
>> Thanks for taking the time to take a look at this.
>>
>>> This should definitely use the V4L2 API. I guess it could be added
>>> to staging/media with a big fat TODO that this should be converted
>>> to
>>> the V4L2 mem2mem framework.
>>>
>>> But it makes no sense to re-invent the V4L2 streaming API :-)
>>>
>>> drivers/media/platform/mx2_emmaprp.c does something similar to
>>> this.
>>> It's a little bit outdated (not using the latest m2m helper
>>> functions)
>>> but it is a good starting point.
>>
>> I looked at the mx2_emmaprp.c and the Samsung G-Scaler M2M driver.
>> IMHO, the main difference between
>> the Hardware registers/capabilities is that mx2_emmaprp driver or the
>> gsc driver, have one scaling "channel"
>> if we might call it. Whereas the HW/IP I have in mind has 4-8 scaling
>> channels.
>>
>> By a scaling channel, I mean an entity of the HW or IP, that can take
>> the following parameters :
>>  - Input height, stride , width, color format, input Y and Cb/Cr
>> physically contiguous memory pointers 
>>  - Output height, stride, width, color format, output Y and Cb/Cr
>> physically contiguous  memory pointers
>>
>> Based on the above parameters, when the above are provided and the IP
>> is started, we get an interrupt on completion.
>> I'm sure you are familiar with this model. However, in the case of
>> this IP, there could be 4-8 such channels and a single interrupt
>> on the completion of the all 4-8 scaling operations.
>>
>> In this IP, we are trying to have 4-8 input sources being scaled by
>> this single piece of hardware, by time multiplexing.
>>
>> An example use case is :
>>
>> Four applications (sources) will feed (enqueue) 4 input buffers to
>> the scaler, the scaler driver will synchronize the programming of
>> these buffers, when the number of buffers received  by the driver
>> meets our batch size (say a batch size of 4), it will kick start the
>> IP. The four applications  will poll on the fd, upon receiving an
>> interrupt from the hardware the poll will unblock. And all four
>> applications can dequeue their respective buffers and display them on
>> a sink.
> 
> You should think of a better scheduling model, it will be really hard
> to design userspace that collaborate in order to optimize the IP usage.
> I think a better approach would be to queue while the IP is busy. These
> queues can then be sorted and prioritized.
> 
>>
>> But each "channel" can be set to do accept its own individual input
>> and output formats. When I went through :
>> https://www.kernel.org/doc/html/v4.14/media/uapi/v4l/open.html#multip
>> le-opens
>>
>> It appears, once an application has invoked VIDIOC_REQBUFS or
>> VIDIOC_CREATE_BUFS, other applications cannot VIDIOC_S_FMT on them.
>> However to maximize the available number of channels, it would be
>> necessary to allow several applications to be able to 
>> perform VIDIOC_S_FMT on the device node in the case of this hardware
>> as different channels can be expected to deal with different scaling
>> operations.
> 
> This does not apply to M2M devices. Each time userspace open an M2M
> device, it will get a different instance (unless there is no more
> resource available). What drivers like Samsung FIMC, GSCALER, MFC. etc.
> do, is that they limit the number of instances (open calls) to the
> number of streams they can handle in parallel. They don't seem to share
> an IRQ when doing batch though.
> 
>>
>> One option is to create a logical /dev/videoX node for each such
>> channel, and have a parent driver perform the interrupt handling,
>> batch size setting and other such common functionalities. Is there a
>> way to allow multiple applications talk to the same video device
>> node/file handle without creating logical video nodes for each
>> channel ?
> 
> FIMC used to expose a node per instance and it was terribly hard to
> use. I don't think this is a good idea.

See Nicolas' answers. The mem2mem framework should work well for you,
I think. The job_ready callback can be used to signal when enough
buffers are queued to satisfy your IP requirements.

BTW, those requirements sound really weird. Is this really how Xilinx
wants to implement this? It's not how scalers are used 'in the real world'.
This whole 'batching' thing is strange.

Regards,

	Hans

> 
>>
>> Please let me know if the description of HW is not clear. I will look
>> forward to hear comments from you.
>>
>>>
>>> So for this series:
>>>
>>> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> If this was added to drivers/staging/media instead and with an
>>> updated
>>> TODO, then we can accept it, but we need to see some real effort
>>> afterwards
>>> to switch this to the right API. Otherwise it will be removed again
>>> after a few kernel cycles.
>>>
>>
>> Many thanks for providing a pathway to get this into
>> drivers/staging/media
>>
>> I will drop this series, and re-send with the driver being placed in
>> drivers/staging/media.
>> I'll add some references to this conversation, so a new reviewer gets
>> some context of what
>> was discussed. In the meanwhile I will look into re-writing this to
>> utilize the M2M V4L2 API.
>>
>>> Regards,
>>>
>>> 	Hans
>>
>>
>> Best Regards,
>> Rohit
>>
>>
>>> -----Original Message-----
>>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>>> Sent: Friday, March 09, 2018 3:58 AM
>>> To: Greg KH <gregkh@linuxfoundation.org>; Rohit Athavale
>>> <RATHAVAL@xilinx.com>
>>> Cc: devel@driverdev.osuosl.org; linux-media@vger.kernel.org
>>> Subject: Re: [PATCH v2 1/3] staging: xm2mvscale: Driver support for
>>> Xilinx M2M
>>> Video Scaler
>>>
>>> On 22/02/18 14:46, Greg KH wrote:
>>>> On Wed, Feb 21, 2018 at 02:43:14PM -0800, Rohit Athavale wrote:
>>>>> This commit adds driver support for the pre-release Xilinx M2M
>>>>> Video
>>>>> Scaler IP. There are three parts to this driver :
>>>>>
>>>>>  - The Hardware/IP layer that reads and writes register of the
>>>>> IP
>>>>>    contained in the scaler_hw_xm2m.c
>>>>>  - The set of ioctls that applications would need to know
>>>>> contained
>>>>>    in ioctl_xm2mvsc.h
>>>>>  - The char driver that consumes the IP layer in xm2m_vscale.c
>>>>>
>>>>> Signed-off-by: Rohit Athavale <rohit.athavale@xilinx.com>
>>>>> ---
>>>>
>>>> I need an ack from the linux-media maintainers before I can
>>>> consider
>>>> this for staging, as this really looks like an "odd" video
>>>> driver...
>>>
>>> This should definitely use the V4L2 API. I guess it could be added
>>> to staging/media with a big fat TODO that this should be converted
>>> to
>>> the V4L2 mem2mem framework.
>>>
>>> But it makes no sense to re-invent the V4L2 streaming API :-)
>>>
>>> drivers/media/platform/mx2_emmaprp.c does something similar to
>>> this.
>>> It's a little bit outdated (not using the latest m2m helper
>>> functions)
>>> but it is a good starting point.
>>>
>>> So for this series:
>>>
>>> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> If this was added to drivers/staging/media instead and with an
>>> updated
>>> TODO, then we can accept it, but we need to see some real effort
>>> afterwards
>>> to switch this to the right API. Otherwise it will be removed again
>>> after a few kernel cycles.
>>>
>>> Regards,
>>>
>>> 	Hans
