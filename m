Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48958 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752856AbeACOaF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 09:30:05 -0500
Date: Wed, 3 Jan 2018 16:30:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v2 1/4] media: ov5695: add support for OV5695 sensor
Message-ID: <20180103143000.527cgl5au43uvvw4@valkosipuli.retiisi.org.uk>
References: <1514534905-21393-1-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514534905-21393-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 29, 2017 at 04:08:22PM +0800, Shunqian Zheng wrote:
> This patch adds driver for Omnivision's ov5695 sensor,
> the driver supports following features:
>  - supported resolutions
>    + 2592x1944 at 30fps
>    + 1920x1080 at 30fps
>    + 1296x972 at 60fps
>    + 1280x720 at 30fps
>    + 640x480 at 120fps
>  - test patterns
>  - manual exposure/gain(analog and digital) control
>  - vblank and hblank
>  - media controller
>  - runtime pm
> 
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>

The same comments I've given on the other driver mostly appear to apply
this one as well.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
