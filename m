Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:36657 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757207AbdLQSDj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 13:03:39 -0500
Subject: Re: [PATCH v5 0/4] NVIDIA Tegra video decoder driver
From: Dmitry Osipenko <digetx@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Rob Herring <robh+dt@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1513038011.git.digetx@gmail.com>
Message-ID: <e011cbc3-c41c-0aef-99ec-c897e57214a7@gmail.com>
Date: Sun, 17 Dec 2017 21:03:33 +0300
MIME-Version: 1.0
In-Reply-To: <cover.1513038011.git.digetx@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.12.2017 03:26, Dmitry Osipenko wrote:
> VDE driver provides accelerated video decoding to NVIDIA Tegra SoC's,
> it is a result of reverse-engineering efforts. Driver has been tested on
> Toshiba AC100 and Acer A500, it should work on any Tegra20 device.
> 
> In userspace this driver is utilized by libvdpau-tegra [0] that implements
> VDPAU interface, so any video player that supports VDPAU can provide
> accelerated video decoding on Tegra20 on Linux.
> 
> [0] https://github.com/grate-driver/libvdpau-tegra

Thierry, driver has been approved by media maintainers and should appear in 4.16
(it is already in -next). Please schedule the DT patches for 4.16, thanks.
