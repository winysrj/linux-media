Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:46757 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbeCZWZE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 18:25:04 -0400
Date: Mon, 26 Mar 2018 17:25:02 -0500
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/3] dt-bindings: display: dw_hdmi.txt: add cec-disable
 property
Message-ID: <20180326072830.iphtbw5mkeciv4kj@rob-hp-laptop>
References: <20180323125915.13986-1-hverkuil@xs4all.nl>
 <20180323125915.13986-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180323125915.13986-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2018 at 01:59:13PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Some boards have both a DesignWare and their own CEC controller.
> The CEC pin is only hooked up to their own CEC controller and not
> to the DW controller.
> 
> Add the cec-disable property to disable the DW CEC controller.
> 
> This particular situation happens on Amlogic boards that have their
> own meson CEC controller.

Seems like we could avoid this by describing how the CEC line is hooked 
up which could be needed for other reasons.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/devicetree/bindings/display/bridge/dw_hdmi.txt | 3 +++
>  1 file changed, 3 insertions(+)
