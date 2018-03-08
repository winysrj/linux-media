Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:36069 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934902AbeCHK3p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 05:29:45 -0500
Received: by mail-ua0-f180.google.com with SMTP id j15so610700uan.3
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2018 02:29:45 -0800 (PST)
Received: from mail-ua0-f173.google.com (mail-ua0-f173.google.com. [209.85.217.173])
        by smtp.gmail.com with ESMTPSA id m33sm19869244uai.42.2018.03.08.02.29.42
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Mar 2018 02:29:42 -0800 (PST)
Received: by mail-ua0-f173.google.com with SMTP id e25so3548664uam.6
        for <linux-media@vger.kernel.org>; Thu, 08 Mar 2018 02:29:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180308094807.9443-1-jacob-chen@iotwrt.com>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 8 Mar 2018 19:29:21 +0900
Message-ID: <CAAFQd5D1FMm4FTugstxk_6bE-QbLeNsMZM6EaVVfN_mu8_RQUA@mail.gmail.com>
Subject: Re: [PATCH v6 00/17] Rockchip ISP1 Driver
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy <jeffy.chen@rock-chips.com>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Jacob Chen <jacob2.chen@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 8, 2018 at 6:47 PM, Jacob Chen <jacob-chen@iotwrt.com> wrote:
> From: Jacob Chen <jacob2.chen@rock-chips.com>
>
> changes in V6:
>   - add mipi txrx phy support
>   - remove bool and enum from uapi header
>   - add buf_prepare op
>   - correct some spelling problems
>   - return all queued buffers when starting stream failed

Thanks Jacob.

For anyone planning to review, especially Hans, who pointed it out in
previous version, g_mbus_config is still there and we're working on
replacing it with something less controversial.

Best regards,
Tomasz
