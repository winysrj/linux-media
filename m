Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:41411 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbeDYT1t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 15:27:49 -0400
Subject: Re: [PATCH/RFC 0/4] Implement standard color keying properties
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-renesas-soc@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
From: Dmitry Osipenko <digetx@gmail.com>
Message-ID: <fc704d59-eee5-c3cd-090d-b5cdd71186be@gmail.com>
Date: Wed, 25 Apr 2018 22:27:41 +0300
MIME-Version: 1.0
In-Reply-To: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

On 17.12.2017 03:17, Laurent Pinchart wrote:
> Hello,
> 
> This patch series is an attempt at implementing standard properties for color
> keying support in the KMS API.

I was looking at implementing colorkey support for NVIDIA Tegra (older Tegra's
in particular) and Daniel Vetter suggested that colorkey should be implemented
as a generic plane property, instead of a custom one that I had in the patch
[0]. I've applied your RFC patch and replaced custom property with the generic,
it works well.

Very likely that all HW should be capable of making pixel completely transparent
when it matches a specified color, that could be one of common modes. Though
there could be limitations, like Tegra's aren't able to do blending-over of
planes if colorkey'ing is enabled. The 'colorkey.mode' property allows driver to
expose both common properties and a custom ones. In case of Tegra we could
implement a common property such that atomic commit will be rejected if planes
blending mode aren't compatible with the enabled colorkey'ing, and have a custom
property for a custom HW-aware application that won't be rejected (for example
Opentegra's Xv extension). The common modes could be derived later, once generic
property will get more usage by a variety of drivers. For now I don't see any
issues with your approach and hope to see this series applied in upstream to get
use of them, please continue your effort.

[0] https://patchwork.kernel.org/patch/10342849/
