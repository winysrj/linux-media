Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:58051 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbcHZCQ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 22:16:26 -0400
To: dri-devel@lists.freedesktop.org
Cc: airlied@linux.ie,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
From: Randy Li <randy.li@rock-chips.com>
Subject: Plan to support Rockchip VPU in DRM, is it a good idea
Message-ID: <a56a7da9-154b-c889-67f6-81bd7e4c7a7d@rock-chips.com>
Date: Fri, 26 Aug 2016 10:13:58 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   We always use some kind of hack work to make our Video Process 
Unit(Multi-format Video Encoder/Decoder) work in kernel. From a 
customize driver(vpu service) to the customize V4L2 driver. The V4L2 
subsystem is really not suitable for the stateless Video process or it 
could make driver too fat.
   After talking to some kindness Intel guys and moving our userspace 
library to VA-API driver, I find the DRM may the good choice for us.
But I don't know whether it is welcome to to submit a video driver in 
DRM subsystem?
   Also our VPU(Video process unit) is not just like the Intel's, we 
don't have VCS, we based on registers to set the encoder/decoder. I 
think we may need a lots of IOCTL then. Also we do have a IOMMU in VPU 
but also not a isolated memory for VPU, I don't know I should use TT 
memory or GEM memory.
   I am actually not a member of the department in charge of VPU, and I 
am just beginning to learning DRM(thank the help from Intel again), I am 
not so good at memory part as well(I am more familiar with CMA not the 
IOMMU way), I may need know guide about the implementations when I am 
going to submit driver, I hope I could get help from someone.

-- 
Randy Li
The third produce department

