Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:58030 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbIRA0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2015 20:26:44 -0400
Date: Fri, 18 Sep 2015 09:26:37 +0900
From: Simon Horman <horms@verge.net.au>
To: William Towle <william.towle@codethink.co.uk>
Cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	linux-sh@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Renesas Lager: Device Tree entries for VIN HDMI input, version 2
Message-ID: <20150918002636.GE12858@verge.net.au>
References: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1439465811-936-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Thu, Aug 13, 2015 at 12:36:48PM +0100, William Towle wrote:
>   Version 2 ... removes some redundant configuration from device nodes,
> and provides some supplementary logic for automatic initialisation of
> state->pdata.default_input based on the hardware present.
> 
>   (Obsoletes corresponding parts of "HDMI and Composite capture on
> Lager...", published previously)
> 
> Cheers,
>   Wills.
> 
> To follow:
> 	[PATCH 1/3] ARM: shmobile: lager dts: Add entries for VIN HDMI input
> 	[PATCH 2/3] media: adv7604: automatic "default-input" selection
> 	[PATCH 3/3] ARM: shmobile: lager dts: specify default-input for

I am wondering about the status of patch 2 of the series,
is it queued-up anywhere?

I am also wondering about the relationship between patch 2 and 3.
Does 3 work without 2? Does 2 make 3 unnecessary?
