Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35673 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752227AbdITUxP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 16:53:15 -0400
Date: Wed, 20 Sep 2017 15:53:13 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt: bindings: media: Document port and endpoint
 numbering
Message-ID: <20170920142438.wva4a5gz7ikfnlyh@rob-hp-laptop>
References: <1505723105-16238-1-git-send-email-sakari.ailus@linux.intel.com>
 <1505723105-16238-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505723105-16238-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 18, 2017 at 11:25:04AM +0300, Sakari Ailus wrote:
> A lot of devices do not need and do not document port or endpoint
> numbering at all, e.g. in case where there's just a single port and a
> single endpoint. Whereas this is just common sense, document it to make it
> explicit.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

This is fine, but bindings should still be explicit. Otherwise, I'm 
wondering if it's a single port/endpoint or they just forgot to document 
it. And I shouldn't have to look at the example to infer that.

Acked-by: Rob Herring <robh@kernel.org>
