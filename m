Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34614 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbdEHROG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 May 2017 13:14:06 -0400
Date: Mon, 8 May 2017 12:14:04 -0500
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz, sebastian.reichel@collabora.co.uk
Subject: Re: [RFC v2 2/3] dt: bindings: Add lens-focus binding for image
 sensors
Message-ID: <20170508171404.tooduk3fyf4aiu2k@rob-hp-laptop>
References: <1493974110-26510-1-git-send-email-sakari.ailus@linux.intel.com>
 <1493974110-26510-3-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493974110-26510-3-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 05, 2017 at 11:48:29AM +0300, Sakari Ailus wrote:
> The lens-focus property contains a phandle to the lens voice coil driver
> that is associated to the sensor; typically both are contained in the same
> camera module.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Rob Herring <robh@kernel.org>
