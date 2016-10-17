Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.140]:40061 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbcJQECw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 00:02:52 -0400
To: hverkuil@xs4all.nl
Cc: pawel@osciak.com, linux-media@vger.kernel.org,
        "linux-rockchip@lists.infradead.org"
        <linux-rockchip@lists.infradead.org>, libva@lists.freedesktop.org,
        eddie.cai@rock-chips.com,
        "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>,
        =?UTF-8?B?5p6X6YeR5Y+R?= <alpha.lin@rock-chips.com>
From: Randy Li <randy.li@rock-chips.com>
Subject: something different ideas from chromium's decoder settings API
Message-ID: <91e1ac78-8a2f-35da-f84f-b35616153860@rock-chips.com>
Date: Mon, 17 Oct 2016 12:02:39 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans and all media staff:
   Recently I have try to run the my VA-API driver in Rockchip RK3399, 
after ported the driver in chromium to request API, it works now.
Thanks to the chromium project effort, both the decoder settings API and 
structures are the same between rk3288 and rk3399.
   However the those v4l2 decoder structures are too different between 
the VA-API, I know those VA-API structures would not enough for our 
situation. If we could expend the VA-API structures, it sounds more easy 
to start up a standard.
   Also creating a new v4l2 fourcc for each format is not convenience, 
also the data format may be a little different, but it is still a part 
of the original data right?
   The slice API and request API are still not clearly, I just put my 
ideas here and hoping more ideas coming.
P.S Does somebody know where the chromium would switch to request API 
instead of the config store?
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

