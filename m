Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:37935 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbeHMUdr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 16:33:47 -0400
Date: Mon, 13 Aug 2018 11:50:31 -0600
From: Rob Herring <robh@kernel.org>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 1/6] dt-bindings: Document the Rockchip VPU bindings
Message-ID: <20180813175031.GA26254@rob-hp-laptop>
References: <20180802200010.24365-1-ezequiel@collabora.com>
 <20180802200010.24365-2-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180802200010.24365-2-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 02, 2018 at 05:00:05PM -0300, Ezequiel Garcia wrote:
> Add devicetree binding documentation for Rockchip Video Processing
> Unit IP.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  .../bindings/media/rockchip-vpu.txt           | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt

Reviewed-by: Rob Herring <robh@kernel.org>
