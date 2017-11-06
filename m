Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:52659 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbdKFVps (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 16:45:48 -0500
Date: Mon, 6 Nov 2017 15:45:46 -0600
From: Rob Herring <robh@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: devicetree@vger.kernel.org, mchehab@s-opensource.com,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        hyun.kwon@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH 1/1] of: Make return types of to_of_node and
 of_fwnode_handle macros consistent
Message-ID: <20171106214546.br4excrvclrxfd7f@rob-hp-laptop>
References: <2117711.dO2rQLXOup@avalon>
 <20171102095918.7041-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102095918.7041-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 02, 2017 at 11:59:18AM +0200, Sakari Ailus wrote:
> (Fixed Mauro's e-mail.)
> 
> to_of_node() macro checks whether the fwnode_handle passed to it is not an
> OF node, and if so, returns NULL in order to be NULL-safe. Otherwise it
> returns the pointer to the OF node which the fwnode_handle contains.
> 
> The problem with returning NULL is that its type was void *, which
> sometimes matters. Explicitly return struct device_node * instead.
> 
> Make a similar change to of_fwnode_handle() as well.
> 
> Fixes: d20dc1493db4 ("of: Support const and non-const use for to_of_node()")
> Fixes: debd3a3b27c7 ("of: Make of_fwnode_handle() safer")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Mauro,
> 
> Could you check whether this addresses the smatch issue with the xilinx
> driver?
> 
> Thanks.
> 
>  include/linux/of.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Acked-by: Rob Herring <robh@kernel.org>
