Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:50914 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753738AbeBGMA3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 07:00:29 -0500
Subject: Re: [PATCH v5 03/16] media: rkisp1: Add user space ABI definitions
To: Shunqian Zheng <zhengsq@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, Joao.Pinto@synopsys.com,
        Luis.Oliveira@synopsys.com, Jose.Abreu@synopsys.com,
        jacob2.chen@rock-chips.com
References: <1514533978-20408-1-git-send-email-zhengsq@rock-chips.com>
 <1514533978-20408-4-git-send-email-zhengsq@rock-chips.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e6160bef-29af-3905-6535-a18cb0caa601@xs4all.nl>
Date: Wed, 7 Feb 2018 13:00:23 +0100
MIME-Version: 1.0
In-Reply-To: <1514533978-20408-4-git-send-email-zhengsq@rock-chips.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/29/17 08:52, Shunqian Zheng wrote:
> From: Jeffy Chen <jeffy.chen@rock-chips.com>
> 
> Add the header for userspace

General note: I saw four cases where this documentation referred to the
datasheet. Three comments on that:

1) You don't say which datasheet.
2) I assume the datasheet is under NDA?
3) You do need to give enough information so a reasonable default can be
   used. I mentioned in an earlier review that creating an initial params
   struct that can be used as a templete would be helpful (or even
   required), and that would be a good place to put such defaults.

Regards,

	Hans
