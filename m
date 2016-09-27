Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:49050 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754902AbcI0Dnq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 23:43:46 -0400
To: linux-media@vger.kernel.org
Cc: "linux-rockchip@lists.infradead.org"
        <linux-rockchip@lists.infradead.org>,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>,
        Hans Verkuil <hverkuil@xs4all.nl>
From: Randy Li <randy.li@rock-chips.com>
Subject: media: rockchip-vpu: I should place the huffman table at kernel or
 userspace ?
Message-ID: <5de5d305-0ecc-a994-d133-63d55c8b1741@rock-chips.com>
Date: Tue, 27 Sep 2016 11:43:35 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello:
   I have just done a JPEG HW encoder for the RK3288. I have been told 
that I can't use the standard way to generate huffman table, the VPU 
supports only 10 levels with a different huffman table.
   If I send the huffman table through the v4l2 extra control, the 
memory copy is requested, although the data is not very large(2 x 64 
bytes) but still a overhead. The other way is to place them in the 
kernel driver, and just define the quality every time it encode a 
picture. But storing in kernel would make the driver a little bigger(2 x 
11 x 64 bytes) and beyond the FIFO job.
   So where Should I place the huffman table?
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

