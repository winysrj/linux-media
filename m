Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:43880 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbeEPIJD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 04:09:03 -0400
Received: by mail-ua0-f195.google.com with SMTP id d4-v6so1974977ual.10
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 01:09:03 -0700 (PDT)
Received: from mail-ua0-f175.google.com (mail-ua0-f175.google.com. [209.85.217.175])
        by smtp.gmail.com with ESMTPSA id x8-v6sm204490uaj.44.2018.05.16.01.09.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 May 2018 01:09:01 -0700 (PDT)
Received: by mail-ua0-f175.google.com with SMTP id e8-v6so1971837uam.13
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 01:09:01 -0700 (PDT)
MIME-Version: 1.0
References: <20180308094807.9443-1-jacob-chen@iotwrt.com> <20180308094807.9443-10-jacob-chen@iotwrt.com>
In-Reply-To: <20180308094807.9443-10-jacob-chen@iotwrt.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 16 May 2018 17:08:49 +0900
Message-ID: <CAAFQd5BZm6+s=o1xEu_+E56R-k+ujAFxfytjA+N_SAcU=4A9FA@mail.gmail.com>
Subject: Re: [PATCH v6 09/17] media: rkisp1: add rockchip isp1 core driver
To: Jacob Chen <jacob-chen@iotwrt.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy <jeffy.chen@rock-chips.com>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Chen Jacob <jacob2.chen@rock-chips.com>,
        =?UTF-8?B?6ZmI5Z+O?= <cc@rock-chips.com>,
        Allon Huang <allon.huang@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob, Shunqian,

On Thu, Mar 8, 2018 at 6:49 PM Jacob Chen <jacob-chen@iotwrt.com> wrote:
[snip]
> +static const struct of_device_id rkisp1_plat_of_match[] = {
> +       {
> +               .compatible = "rockchip,rk3288-cif-isp",
> +               .data = &rk3288_isp_clk_data,
> +       }, {
> +               .compatible = "rockchip,rk3399-cif-isp",
> +               .data = &rk3399_isp_clk_data,
> +       },
> +       {},
> +};

We need MODULE_DEVICE_TABLE() here.

Best regards,
Tomasz
