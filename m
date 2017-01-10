Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:16823 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759938AbdAJOyE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 09:54:04 -0500
From: Vincent ABRIOU <vincent.abriou@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [media] uvcvideo: support for contiguous DMA buffers
Date: Tue, 10 Jan 2017 14:53:59 +0000
Message-ID: <52c97270-299a-9c1c-5475-109815334f11@st.com>
References: <1475494036-18208-1-git-send-email-vincent.abriou@st.com>
 <3193570.QBsjjzBjh2@avalon> <93a7f73c-0c0f-64cb-5918-e86add84b006@st.com>
 <2642368.koo1zFQjyt@avalon>
In-Reply-To: <2642368.koo1zFQjyt@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <49BD20C92FD3E147AB7F228AB6CDFF62@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/10/2017 03:41 PM, Laurent Pinchart wrote:
> On Tuesday 10 Jan 2017 08:55:16 Vincent ABRIOU wrote:
>> On 01/09/2017 05:59 PM, Laurent Pinchart wrote:
>>> On Monday 09 Jan 2017 15:49:00 Vincent ABRIOU wrote:
>>>> On 01/09/2017 04:37 PM, Laurent Pinchart wrote:
>>>>> Hi Vincent,
>>>>>
>>>>> Thank you for the patch.
>>>>>
>>>>> On Monday 03 Oct 2016 13:27:16 Vincent Abriou wrote:
>>>>>> Allow uvcvideo compatible devices to allocate their output buffers
>>>>>> using contiguous DMA buffers.
>>>>>
>>>>> Why do you need this ? If it's for buffer sharing with a device that
>>>>> requires dma-contig, can't you allocate the buffers on the other device
>>>>> and import them on the UVC side ?
>>>>
>>>> Hi Laurent,
>>>>
>>>> I need this using Gstreamer simple pipeline to connect an usb webcam
>>>> (v4l2src) with a display (waylandsink) activating the zero copy path.
>>>>
>>>> The waylandsink plugin does not have any contiguous memory pool to
>>>> allocate contiguous buffer. So it is up to the upstream element, here
>>>> v4l2src, to provide such contiguous buffers.
>>>
>>> Isn't that a gstreamer issue ?
>>
>> It is not a gstreamer issue. It is the way it has been decided to work.
>> Waylandsink accept DMABUF contiguous buffer but it does not have its own
>> buffer pool.
>
> But why do you put the blame on the kernel when you decide to take the wrong
> decision in userspace ? :-)
>

I don't blame the kernel... I improve it :)

>>>>>> Add the "allocators" module parameter option to let uvcvideo use the
>>>>>> dma-contig instead of vmalloc.
>>>>>>
>>>>>> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
>>>>>> ---
>>>>>>
>>>>>>  Documentation/media/v4l-drivers/uvcvideo.rst | 12 ++++++++++++
>>>>>>  drivers/media/usb/uvc/Kconfig                |  2 ++
>>>>>>  drivers/media/usb/uvc/uvc_driver.c           |  3 ++-
>>>>>>  drivers/media/usb/uvc/uvc_queue.c            | 23 ++++++++++++++++---
>>>>>>  drivers/media/usb/uvc/uvcvideo.h             |  4 ++--
>>>>>>  5 files changed, 38 insertions(+), 6 deletions(-)
>