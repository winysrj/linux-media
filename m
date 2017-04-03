Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32906 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753013AbdDCO2H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 10:28:07 -0400
Date: Mon, 3 Apr 2017 09:28:05 -0500
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv6 06/14] atmel-isi: update device tree bindings
 documentation
Message-ID: <20170403142805.tybemhb2xe5jvhwx@rob-hp-laptop>
References: <20170328082347.11159-1-hverkuil@xs4all.nl>
 <20170328082347.11159-7-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170328082347.11159-7-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:23:39AM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The original bindings documentation was incomplete (missing pinctrl-names,
> missing endpoint node properties) and the example was out of date.
> 
> Add the missing information and tidy up the text.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  .../devicetree/bindings/media/atmel-isi.txt        | 91 +++++++++++++---------
>  1 file changed, 53 insertions(+), 38 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
