Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 243C5C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 22:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3519214D8
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 22:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552344108;
	bh=T4d3bzHQRcayBAPdRMLxv0rUZJIeCyBP9xBDFwH6zn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xkH3jtN5yVl4lqcM8WDRcFq0w5QXwtWD2QwJGIAbOXheo3y1/w2Z9edGbNcfUT32S
	 TdzkD7YtfyXyGNs7lADbYnXgKOWyr2tefSFnFNc3WbDz76b2JKJijUmRsq36FqPsqm
	 1UDcRjsCqrScWlq/j3e3nfz6nFK2Wj8nBgibiot8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfCKWln (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 18:41:43 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41624 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfCKWlm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 18:41:42 -0400
Received: by mail-ot1-f67.google.com with SMTP id t7so714091otk.8;
        Mon, 11 Mar 2019 15:41:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TJML0uGfLYj5LcXJ4ZSv+L1LfESaD+LndKo9tAnKPnI=;
        b=cnDETFtzpm/6T7qD/hQdFn3FVyVU/fw+mzt7BVGSC8ohbTJ+YS6D4DnP/T/5aDfEBn
         rJCU5WTxFp7iJ0xn8J+JpzkdpyH3WnlvZHixsYzpi11G6NAZa0rEzgGByumm/XbFxODQ
         efneTvxrXiSGUfjqz8EatyRtLMcn85XC5lCUcn9nWITlEE0OXvMNZwfs95/Cpbxt/2j2
         ACLorxOXBQDRjiqulvzJs6sttzdQcLpACMWi4CmMBVxB15ioqnA6xFKBRj6o+IF1y6QH
         V82PjxnF78K4QxqIwOPxYylAxpiy1jdbBG59wA0Ru1o8wWV26vf5siRVwEOqSbYxISs/
         8kaw==
X-Gm-Message-State: APjAAAWvOE1VS3FKnM48lybbOm4Wcl5m31i9PrUEBZEzDYb1ugFSDQ+3
        oiYlmE+O8gBZaVHixA8GEg==
X-Google-Smtp-Source: APXvYqws1Fdg+l1hnYj9cI/erwrOqcnhpIHzvFFUQZLzfYiJM4C1GtLrQALvmc7rI4HYL33tYX2w3g==
X-Received: by 2002:a9d:130:: with SMTP id 45mr23236431otu.355.1552344101336;
        Mon, 11 Mar 2019 15:41:41 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id o4sm194581oih.45.2019.03.11.15.41.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 15:41:40 -0700 (PDT)
Date:   Mon, 11 Mar 2019 17:41:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vishal Sagar <vishal.sagar@xilinx.com>
Cc:     Hyun Kwon <hyunk@xilinx.com>, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        Michal Simek <michals@xilinx.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dinesh Kumar <dineshk@xilinx.com>,
        Sandip Kothari <sandipk@xilinx.com>,
        Vishal Sagar <vishal.sagar@xilinx.com>
Subject: Re: [PATCH v5 1/2] media: dt-bindings: media: xilinx: Add Xilinx
 MIPI CSI-2 Rx Subsystem
Message-ID: <20190311224140.GA23484@bogus>
References: <1552297257-145919-1-git-send-email-vishal.sagar@xilinx.com>
 <1552297257-145919-2-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552297257-145919-2-git-send-email-vishal.sagar@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, 11 Mar 2019 15:10:56 +0530, Vishal Sagar wrote:
> Add bindings documentation for Xilinx MIPI CSI-2 Rx Subsystem.
> 
> The Xilinx MIPI CSI-2 Rx Subsystem consists of a CSI-2 Rx controller, a
> DPHY in Rx mode, an optional I2C controller and a Video Format Bridge.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>
> ---
> v5
> - Incorporated comments by Luca Cersoli
> - Removed DPHY clock from description and example
> - Removed bayer pattern from device tree MIPI CSI IP
>   doesn't deal with bayer pattern.
> 
> v4
> - Added reviewed by Hyun Kwon
> 
> v3
> - removed interrupt parent as suggested by Rob
> - removed dphy clock
> - moved vfb to optional properties
> - Added required and optional port properties section
> - Added endpoint property section
> 
> v2
> - updated the compatible string to latest version supported
> - removed DPHY related parameters
> - added CSI v2.0 related property (including VCX for supporting upto 16
>   virtual channels).
> - modified csi-pxl-format from string to unsigned int type where the value
>   is as per the CSI specification
> - Defined port 0 and port 1 as sink and source ports.
> - Removed max-lanes property as suggested by Rob and Sakari
> 
>  .../bindings/media/xilinx/xlnx,csi2rxss.txt        | 118 +++++++++++++++++++++
>  1 file changed, 118 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,csi2rxss.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
