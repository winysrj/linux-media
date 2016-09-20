Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.140]:53760 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbcITBSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 21:18:35 -0400
To: hverkuil@xs4all.nl
Cc: pawel@osciak.com, linux-media@vger.kernel.org,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>,
        "libva@lists.freedesktop.org" <libva@lists.freedesktop.org>,
        "eddie.cai " <eddie.cai@rock-chips.com>,
        "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>
From: Randy Li <randy.li@rock-chips.com>
Subject: Summary of the discussion about Rockchip VPU in Gstreamer
Message-ID: <b6bcee79-ec58-872c-adad-3e6d318d6930@rock-chips.com>
Date: Tue, 20 Sep 2016 09:18:24 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all media staff
Dear Mr.Verkuil
Dear Mr.Osciak
  I talked with Nicolas and Mr.ceyusa in the yesterday and early morning 
of today.
   I think I have made them get the situation of state-less Video 
Acceleration Unit(VPU) and Rockchip for VA-API driver. We both agree 
that creating a new C API bindings to V4L2 is making wheel again. 
Mr.Ceyusa suggest that there could be a middle library to parse those 
codec settings to V4L2 extra controls array, and push back to Gstreamer, 
leaving the V4L2 related job to Gstreamer.
   I agree with him. I think the Gstreamer then could get rid of 
hardware detail, even not need to know internal data structure in kernel 
driver of codec parameters.
   Later, the ad-n770 joined us. He gave me some idea about the 
relationship with VA-API and DXVA2. I found we do need some extra data 
beyond those data used by VA-API to reconstruct a frame, it is a 
limitation in HW. We better regard this kind of HW to a Acceleration 
Unit rather than Full decoder/Encoder. Also ad-n770 pointer out that it 
seems that Rockchip HW could do the reodering job, which is not need 
actually as it is done by Gstreamer, but I am not sure whether the 
Hardware does and I could disable this logic.
   I am sorry I can't attend the conference in Berlin. But I hope we 
could keep in discussion in this topic, and offering more information to 
you before the meetings.
   Currently, I would still work on VA-API framework and I am learning 
something about codec through a book, I hope that it make me explaining 
the situation easily.

-- 
Randy Li
The third produce department
===========================================================================
This email message, including any attachments, is for the sole
use of the intended recipient(s) and may contain confidential and
privileged information. Any unauthorized review, use, disclosure or
distribution is prohibited. If you are not the intended recipient, please
contact the sender by reply e-mail and destroy all copies of the original
message. [Fuzhou Rockchip Electronics, INC. China mainland]
===========================================================================

