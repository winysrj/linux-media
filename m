Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:37272 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbeGaAG1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 20:06:27 -0400
Date: Mon, 30 Jul 2018 16:29:19 -0600
From: Rob Herring <robh@kernel.org>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 08/34] media: dt-bindings: media: qcom,camss: Unify
 the clock names
Message-ID: <20180730222919.GA9313@rob-hp-laptop>
References: <1532536723-19062-1-git-send-email-todor.tomov@linaro.org>
 <1532536723-19062-9-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1532536723-19062-9-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 25, 2018 at 07:38:17PM +0300, Todor Tomov wrote:
> Use more logical clock names - similar to the names in documentation.
> This will allow better handling of the clocks in the driver when support
> for more hardware versions is added - equivalent clocks on different
> hardware versions will have the same name.

You should note that no dts is using this yet (at least that's what I 
found).

> 
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: devicetree@vger.kernel.org
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  .../devicetree/bindings/media/qcom,camss.txt       | 24 +++++++++++-----------
>  1 file changed, 12 insertions(+), 12 deletions(-)

With that,

Reviewed-by: Rob Herring <robh@kernel.org>
