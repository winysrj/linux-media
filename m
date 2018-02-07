Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:50350 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753763AbeBGMi4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 07:38:56 -0500
Subject: Re: [PATCH v5 03/16] media: rkisp1: Add user space ABI definitions
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org
Cc: Jose.Abreu@synopsys.com, devicetree@vger.kernel.org,
        eddie.cai.linux@gmail.com, Joao.Pinto@synopsys.com,
        heiko@sntech.de, jacob2.chen@rock-chips.com,
        jeffy.chen@rock-chips.com, zyc@rock-chips.com,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        Luis.Oliveira@synopsys.com, robh+dt@kernel.org,
        hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
        sakari.ailus@linux.intel.com, allon.huang@rock-chips.com,
        mchehab@kernel.org, linux-arm-kernel@lists.infradead.org
References: <1514533978-20408-1-git-send-email-zhengsq@rock-chips.com>
 <1514533978-20408-4-git-send-email-zhengsq@rock-chips.com>
 <5b29d890-8c6b-18ff-ade1-1923c25143a0@xs4all.nl>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <d29bc615-2359-86c6-db5a-27cc111bc275@arm.com>
Date: Wed, 7 Feb 2018 12:38:50 +0000
MIME-Version: 1.0
In-Reply-To: <5b29d890-8c6b-18ff-ade1-1923c25143a0@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/02/18 13:14, Hans Verkuil wrote:
[...]
> The one thing that I worry about is if these structs are the same for
> 32 and 64 bit arm.

I see some enums and bools in there - in general the storage size of 
those isn't even guaranteed to be consistent between different compiler 
implementations on the same platform, let alone across multiple 
platforms (especially WRT things like GCC's -fshort-enums).

In practice, under the standard ABIs for 32-bit and 64-bit Arm[1], I'd 
expect basic types other than longs and pointers to be pretty much the 
same; it's the imp-def C stuff I'd be a lot less confident about.

Robin.

[1]:http://infocenter.arm.com/help/topic/com.arm.doc.subset.swdev.abi/index.html
