Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50097 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbeJSUYb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:24:31 -0400
Message-ID: <1539951519.3395.12.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/16] i.MX media mem2mem scaler
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Date: Fri, 19 Oct 2018 14:18:39 +0200
In-Reply-To: <fd6ffc20-7493-1588-7699-8be68eb74641@mentor.com>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
         <cc2a7233-2761-902b-843a-0e3f458f230b@gmail.com>
         <fd6ffc20-7493-1588-7699-8be68eb74641@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Wed, 2018-10-17 at 16:46 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> On 10/12/18 5:29 PM, Steve Longerbeam wrote:
> > <snip>
> > 
> > But one last thing. Conversions to and from YV12 are producing images
> > with wrong colors, it looks like the .uv_swapped boolean needs to be 
> > checked
> > additionally somewhere. Any ideas?
> 
> 
> Sorry, this was my fault. I fixed this in
> 
> "gpu: ipu-v3: Add chroma plane offset overrides to ipu_cpmem_set_image()"
> 
> in my fork git@github.com:slongerbeam/mediatree.git, branch imx-mem2mem.3.
> 
> Steve

Thanks a lot for testing, fixes, and integration. Basically I've just
resubmitted that branch as v4.
After this round I'll pick up all non-controversial ipu-v3 / image-
convert patches.

regards
Philipp
