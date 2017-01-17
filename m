Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.139]:39472 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdAQDE7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 22:04:59 -0500
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, pawel@osciak.com,
        "ayaka@soulik.info" <ayaka@soulik.info>,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>,
        florent.revest@free-electrons.com, hugues.fruchet@st.com,
        "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>
From: Randy Li <randy.li@rock-chips.com>
Subject: Request API: stateless VPU: the buffer mechanism and DPB management
Message-ID: <c09c78e4-d825-8af4-4309-8ef051043ed8@rock-chips.com>
Date: Tue, 17 Jan 2017 11:04:40 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
-- 
Randy Li
The third produce department

