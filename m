Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:64796 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752995AbdAKMgd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 07:36:33 -0500
From: Vincent ABRIOU <vincent.abriou@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Hugues FRUCHET <hugues.fruchet@st.com>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Subject: Re: [media] uvcvideo: support for contiguous DMA buffers
Date: Wed, 11 Jan 2017 12:36:24 +0000
Message-ID: <45eec54c-059e-86c1-bedb-78a6400328a4@st.com>
References: <1475494036-18208-1-git-send-email-vincent.abriou@st.com>
 <5308977.1AOWxa0Moe@avalon> <c86650e5-7106-d36b-b716-6247fb2fa8ed@st.com>
 <20170111110350.GE10831@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170111110350.GE10831@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <90F0841DFC9CB1468CEF592CF26F04BA@st.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/11/2017 12:03 PM, Sakari Ailus wrote:
> Hi Vincent,
>
> On Mon, Jan 09, 2017 at 03:49:00PM +0000, Vincent ABRIOU wrote:
>>
>>
>> On 01/09/2017 04:37 PM, Laurent Pinchart wrote:
>>> Hi Vincent,
>>>
>>> Thank you for the patch.
>>>
>>> On Monday 03 Oct 2016 13:27:16 Vincent Abriou wrote:
>>>> Allow uvcvideo compatible devices to allocate their output buffers using
>>>> contiguous DMA buffers.
>>>
>>> Why do you need this ? If it's for buffer sharing with a device that requires
>>> dma-contig, can't you allocate the buffers on the other device and import them
>>> on the UVC side ?
>>>
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
> Do you need (physically) contiguous memory?
>

Yes, drm driver that does not have mmu needs to have contiguous buffers.

> The DMA-BUF API does help sharing the buffers but it, at least currently,
> does not help allocating memory or specifying a common format so that all
> the devices the buffer needs to be accessible can actually make use of it.
>
> Instead of hacking drivers to make use of different memory allocation
> strategies required by unrelated devices, we should instead fix these
> problems in a proper, scalable way.
>

Scalable way? Like central allocator?

Vincent