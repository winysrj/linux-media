Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45695 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751365AbeDYTdZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 15:33:25 -0400
Subject: Re: [PATCH/RFC 1/4] drm: Add colorkey properties
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171217001724.1348-2-laurent.pinchart+renesas@ideasonboard.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <2cf83ece-fc42-02ee-9234-10645eec1cb1@gmail.com>
Date: Wed, 25 Apr 2018 22:33:21 +0300
MIME-Version: 1.0
In-Reply-To: <20171217001724.1348-2-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.12.2017 03:17, Laurent Pinchart wrote:
> Color keying is the action of replacing pixels matching a given color
> (or range of colors) with transparent pixels in an overlay when
> performing blitting. Depending on the hardware capabilities, the
> matching pixel can either become fully transparent, or gain a
> programmable alpha value.
> 
> Color keying is found in a large number of devices whose capabilities
> often differ, but they still have enough common features in range to
> standardize color key properties. This commit adds four properties
> related to color keying named colorkey.min, colorkey.max, colorkey.alpha
> and colorkey.mode. Additional properties can be defined by drivers to
> expose device-specific features.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>

Note that this patch needs to be rebased now.
