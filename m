Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:58905 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbcFQUOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 16:14:19 -0400
Subject: Re: [PATCH 31/38] media: imx: Add video switch
To: Ian Arkver <ian.arkver.dev@gmail.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	<linux-media@vger.kernel.org>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1465944574-15745-32-git-send-email-steve_longerbeam@mentor.com>
 <a0771fe0-ab96-1f33-703f-e224f056390f@gmail.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <57645A17.30909@mentor.com>
Date: Fri, 17 Jun 2016 13:14:15 -0700
MIME-Version: 1.0
In-Reply-To: <a0771fe0-ab96-1f33-703f-e224f056390f@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 09:13 AM, Ian Arkver wrote:
> For me this fails when I try to enable both video muxes (mx6dl, though 
> mx6q should be the same).
>
> I get a sysfs duplicate name failure for 34.videomux. I realise 
> passing the GPR13 register offset and a bitfield mask as a tuple in 
> the reg value of the of_node is handy, but how should we account for 
> multiple devices with the same name and address?
>
> A quick and dirty hack would be to have of_get_reg_field do something 
> like
>
>     field->reg = reg_bit_mask[0] & 0xff;
>
> and then use values in the DT that differ in the bits masked off, but 
> there must be a nicer way.
>
> Trace below, fyi. This is from the v2 patches posted here, not your 
> v2.1 tree.
>

Hi Ian,

Thanks for catching this. I found a simple and clean solution to this
problem: just rename the video-mux node from "videomux" to
"ipu[12]_csi[01]_mux". It makes the subdev names more descriptive
anyway. I've applied that change to my mx6-media-staging-v2.1
branch.

Steve

