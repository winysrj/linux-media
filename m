Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:49894 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729262AbeJAUEO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 16:04:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andrea Merello <andrea.merello@gmail.com>, hyun.kwon@xilinx.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Mirco Di Salvo <mirco.disalvo@iit.it>
Subject: Re: [PATCH] [media] v4l: xilinx: fix typo in formats table
Date: Mon, 01 Oct 2018 16:26:41 +0300
Message-ID: <118342352.6u92UtmAFX@avalon>
In-Reply-To: <05f39fbf-7097-9d89-c019-c2398aed2201@xilinx.com>
References: <20180928073213.10022-1-andrea.merello@gmail.com> <1859576.n3v8JWS4oW@avalon> <05f39fbf-7097-9d89-c019-c2398aed2201@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michal,

On Monday, 1 October 2018 15:45:49 EEST Michal Simek wrote:
> On 28.9.2018 14:52, Laurent Pinchart wrote:
> > On Friday, 28 September 2018 10:32:13 EEST Andrea Merello wrote:
> >> In formats table the entry for CFA pattern "rggb" has GRBG fourcc.
> >> This patch fixes it.
> >> 
> >> Cc: linux-media@vger.kernel.org
> >> Signed-off-by: Mirco Di Salvo <mirco.disalvo@iit.it>
> >> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Michal, should I take the patch in my tree ?
> 
> definitely. I am not collecting patches for media tree.

Taken in my tree.

By the way, have we reached any conclusion regarding https://lkml.org/lkml/
2017/12/18/112 ?

-- 
Regards,

Laurent Pinchart
