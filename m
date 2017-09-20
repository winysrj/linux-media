Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33537 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752230AbdITUxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 16:53:16 -0400
Date: Wed, 20 Sep 2017 15:53:14 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt: bindings: media: Document data lane numbering
 without lane reordering
Message-ID: <20170920205314.qv6hu4g3mxm3qqm4@rob-hp-laptop>
References: <1505723105-16238-1-git-send-email-sakari.ailus@linux.intel.com>
 <1505723105-16238-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505723105-16238-3-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 18, 2017 at 11:25:05AM +0300, Sakari Ailus wrote:
> Most devices do not support lane reordering and in many cases the
> documentation of the data-lanes property is incomplete for such devices.
> Document that in case the lane reordering isn't supported, monotonically
> incremented values from 0 or 1 shall be used.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Acked-by: Rob Herring <robh@kernel.org>
