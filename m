Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:37831 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752217AbdIMU2s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 16:28:48 -0400
Date: Wed, 13 Sep 2017 15:28:46 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] dt: bindings: as3645a: Use LED number to refer to
 LEDs
Message-ID: <20170913202846.ax3ubqnlbiaatfmf@rob-hp-laptop>
References: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
 <20170908124213.18904-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908124213.18904-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 08, 2017 at 03:42:12PM +0300, Sakari Ailus wrote:
> Use integers (reg property) to tell the number of the LED to the driver
> instead of the node name. While both of these approaches are currently
> used by the LED bindings, using integers will require less driver changes
> for ACPI support. Additionally, it will make possible LED naming using
> chip and LED node names, effectively making the label property most useful
> for human-readable names only.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../devicetree/bindings/leds/ams,as3645a.txt       | 28 ++++++++++++++--------
>  1 file changed, 18 insertions(+), 10 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
