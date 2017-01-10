Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:27352 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750827AbdAJIzW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 03:55:22 -0500
From: Vincent ABRIOU <vincent.abriou@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [media] uvcvideo: support for contiguous DMA buffers
Date: Tue, 10 Jan 2017 08:55:16 +0000
Message-ID: <93a7f73c-0c0f-64cb-5918-e86add84b006@st.com>
References: <1475494036-18208-1-git-send-email-vincent.abriou@st.com>
 <5308977.1AOWxa0Moe@avalon> <c86650e5-7106-d36b-b716-6247fb2fa8ed@st.com>
 <3193570.QBsjjzBjh2@avalon>
In-Reply-To: <3193570.QBsjjzBjh2@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3BFB271831469540A9CA586EDE0889EA@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/09/2017 05:59 PM, Laurent Pinchart wrote:
> Hi Vincent,
>
> (CC'ing Nicolas)
>
> On Monday 09 Jan 2017 15:49:00 Vincent ABRIOU wrote:
>> On 01/09/2017 04:37 PM, Laurent Pinchart wrote:
>>> Hi Vincent,
>>>
>>> Thank you for the patch.
>>>
>>> On Monday 03 Oct 2016 13:27:16 Vincent Abriou wrote:
>>>> Allow uvcvideo compatible devices to allocate their output buffers using
>>>> contiguous DMA buffers.
>>>
>>> Why do you need this ? If it's for buffer sharing with a device that
>>> requires dma-contig, can't you allocate the buffers on the other device
>>> and import them on the UVC side ?
>>
>> Hi Laurent,
>>
>> I need this using Gstreamer simple pipeline to connect an usb webcam
>> (v4l2src) with a display (waylandsink) activating the zero copy path.
>>
>> The waylandsink plugin does not have any contiguous memory pool to
>> allocate contiguous buffer. So it is up to the upstream element, here
>> v4l2src, to provide such contiguous buffers.
>
> Isn't that a gstreamer issue ?
>

It is not a gstreamer issue. It is the way it has been decided to work.
Waylandsink accept DMABUF contiguous buffer but it does not have its own 
buffer pool.

Vincent

>>>> Add the "allocators" module parameter option to let uvcvideo use the
>>>> dma-contig instead of vmalloc.
>>>>
>>>> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
>>>> ---
>>>>
>>>>  Documentation/media/v4l-drivers/uvcvideo.rst | 12 ++++++++++++
>>>>  drivers/media/usb/uvc/Kconfig                |  2 ++
>>>>  drivers/media/usb/uvc/uvc_driver.c           |  3 ++-
>>>>  drivers/media/usb/uvc/uvc_queue.c            | 23 ++++++++++++++++++---
>>>>  drivers/media/usb/uvc/uvcvideo.h             |  4 ++--
>>>>  5 files changed, 38 insertions(+), 6 deletions(-)
>