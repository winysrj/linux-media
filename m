Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42137 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932653AbeEaDdd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 23:33:33 -0400
Date: Wed, 30 May 2018 22:33:31 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com, sebastian.reichel@collabora.co.uk
Subject: Re: [PATCH v2 1/2] dt-bindings: media: Define "rotation" property
 for sensors
Message-ID: <20180531033331.GA25703@rob-hp-laptop>
References: <20180525122726.3409-1-sakari.ailus@linux.intel.com>
 <20180525122726.3409-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525122726.3409-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 03:27:25PM +0300, Sakari Ailus wrote:
> Sensors are occasionally mounted upside down to systems such as mobile
> phones or tablets. In order to use such a sensor without having to turn
> every image upside down, most camera sensors support reversing the readout
> order by setting both horizontal and vertical flipping.
> 
> This patch documents the "rotation" property for camera sensors, mirroring
> what is defined for displays in
> Documentation/devicetree/bindings/display/panel/panel.txt .
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
