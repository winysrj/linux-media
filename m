Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:54302 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdAQPdH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jan 2017 10:33:07 -0500
Subject: Re: Request API: stateless VPU: the buffer mechanism and DPB
 management
To: nicolas.dufresne@collabora.com,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <c09c78e4-d825-8af4-4309-8ef051043ed8@rock-chips.com>
 <2017011720451777881856@rock-chips.com>
 <1484665142.7839.3.camel@collabora.co.uk>
Cc: "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>,
        =?UTF-8?B?5p2O5aSP5ram?= <randy.li@rock-chips.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, pawel <pawel@osciak.com>,
        "florent.revest" <florent.revest@free-electrons.com>,
        "hugues.fruchet" <hugues.fruchet@st.com>
From: ayaka <ayaka@soulik.info>
Message-ID: <96652516-e61e-7ef4-221f-26952f03390e@soulik.info>
Date: Tue, 17 Jan 2017 23:32:19 +0800
MIME-Version: 1.0
In-Reply-To: <1484665142.7839.3.camel@collabora.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/17/2017 10:59 PM, Nicolas Dufresne wrote:
> Le mardi 17 janvier 2017 à 20:46 +0800, herman.chen@rock-chips.com a
> écrit :
>> If we move parser or part of DPB management mechanism into kernel we
>> will face a issue as follows:
>> One customer requires dpb management do a flush when stream occurs in
>> order to keep output frame clean.
>> While another one requires output frame with error to keep output
>> frame smooth.
>> And when only one field has a error one customer wants to do a simple
>> field copy to recover.
> The driver should send all frames and simply mark the corrupted frames
> using V4L2_BUF_FLAG_ERROR. This way, the userspace can then make their
> own decision. It is also important to keep track and cleanup the
> buffers meta's (which are application specific). If the driver silently
> drops frame, it makes that management much harder.
>
> About flushing and draining operation, they are respectively signalled
> to the driver using STREAMOFF and CMD_STOP.
>
>> These are some operation related to strategy rather then mechanism.
>> I think it is not a good idea to bring such kind of flexible process
>> to kernel driver.
>>
>> So here is the ultimate challenge that how to reasonably move the
>> parser and flexible process
>> which is encapsuled in firmware to a userspace - kernel stateless
>> driver model.
> Moving the parsers in the kernel (on the main CPU) is not acceptable.
No, what is not what I said. What I want to do is "The whole plan in 
userspace is just injecting a parsing operation and set those v4l2 
control in kernel before enqueue a buffer into OUTPUT, which would keep 
the most compatible with those stateful video IP(those with a firmware). "
> This is too much of a security threat. Userspace should parse the data
> into structures, doing any validation required before end.
>
> My main question and that should have an impact decision, is if those
> structures can be made generic. PDB handling is not that trivial (my
> reference is VAAPI here, maybe they are doing it wrong) and with driver
> specific structures, we would have this code copy-pasted over and over.
> So with driver specific structures, it's probably better to keep all
> the parsing and reordering logic outside (hence together).
The result to keep DPB and re-order inside the kernel is want
to be compatible with the original buffer operation.
Anyway the DPB structure could be common.
>
> That remains, that some driver will deal with reordering on the
> firmware side (even the if they don't parse), hence we need to take
> this into consideration.
No sure what do you mean, I think all those driver with firmware
would do that.
>
> regards,
> Nicolas

Hello all:
   I have recently finish the learning of the H.264 codec and ready to 
write the driver. Although I have not get deep in syntax of H.264 but I 
think I just need to reuse and extended the VA-API H264 Parser from 
gstreamer. The whole plan in userspace is just injecting a parsing 
operation and set those v4l2 control in kernel before enqueue a buffer 
into OUTPUT, which would keep the most compatible with those stateful 
video IP(those with a firmware).
   But in order to do that, I can't avoid the management of DPB. I 
decided to moving the DPB management job from userspace in kernel. Also 
the video IP(On2 on rk3288 and the transition video IP on those future 
SoC than rk3288, rkv don't have this problem) would a special way to 
manage the DPB, which requests the same reference frame is storing in 
the same reference index in the runtime(actually it is its Motion Vector 
data appended in decoded YUV data would not be moved). I would suggest 
to keep those job in kernel, the userspace just to need update the list0 
and list1 of DPB. DPB is self managed in kernel the userspace don't need 
to even dequeue the buffer from CAPTURE until the re-order is done.
   The kernel driver would also re-order the CAPTURE buffer into display 
order, and blocking the operation on CAPTURE until a buffer is ready to 
place in the very display order. If I don't do that, I have to get the 
buffer once it is decoded, and marking its result with the poc, I could 
only begin the processing of the next frame only after those thing are 
done. Which would effect the performance badly. That is what chromebook 
did(I hear that from the other staff, I didn't get invoke in chromium 
project yet). So I would suggest that doing the re-order job in kernel, 
and inform the the userspace the buffers are ready when the new I 
frame(key frame) is pushed into the video IP.
   Although moving those job into kernel would increase the loading, but 
I think it is worth to do that, but I don't know whether all those 
thought are correct and high performance(It is more important than API 
compatible especially for those 4K video). And I want to know more ideas 
about this topic.
   I would begin the writing the new driver after the coming culture new 
year vacation(I would go to the Europe), I wish we can decide the final 
mechanism before I begin this job.
