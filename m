Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:46325 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbeJRHot (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 03:44:49 -0400
Subject: Re: [PATCH v3 00/16] i.MX media mem2mem scaler
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-media@vger.kernel.org>
CC: Nicolas Dufresne <nicolas@ndufresne.ca>, <kernel@pengutronix.de>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
 <cc2a7233-2761-902b-843a-0e3f458f230b@gmail.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <fd6ffc20-7493-1588-7699-8be68eb74641@mentor.com>
Date: Wed, 17 Oct 2018 16:46:28 -0700
MIME-Version: 1.0
In-Reply-To: <cc2a7233-2761-902b-843a-0e3f458f230b@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 10/12/18 5:29 PM, Steve Longerbeam wrote:
> <snip>
>
> But one last thing. Conversions to and from YV12 are producing images
> with wrong colors, it looks like the .uv_swapped boolean needs to be 
> checked
> additionally somewhere. Any ideas?


Sorry, this was my fault. I fixed this in

"gpu: ipu-v3: Add chroma plane offset overrides to ipu_cpmem_set_image()"

in my fork git@github.com:slongerbeam/mediatree.git, branch imx-mem2mem.3.

Steve
