Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47387 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753677AbdLNS2T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 13:28:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Dhaval Shah <dhaval23031987@gmail.com>, hyun.kwon@xilinx.com,
        michal.simek@xilinx.com, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
Date: Thu, 14 Dec 2017 20:28:25 +0200
Message-ID: <7339763.I7jApfYMM6@avalon>
In-Reply-To: <20171214150527.00dca6cc@vento.lan>
References: <20171208123537.18718-1-dhaval23031987@gmail.com> <20171214150527.00dca6cc@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday, 14 December 2017 19:05:27 EET Mauro Carvalho Chehab wrote:
> Em Fri,  8 Dec 2017 18:05:37 +0530 Dhaval Shah escreveu:
> > SPDX-License-Identifier is used for the Xilinx Video IP and
> > related drivers.
> > 
> > Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
> 
> Hi Dhaval,
> 
> You're not listed as one of the Xilinx driver maintainers. I'm afraid that,
> without their explicit acks, sent to the ML, I can't accept a patch
> touching at the driver's license tags.

The patch doesn't change the license, I don't see why it would cause any 
issue. Greg isn't listed as the maintainer or copyright holder of any of the 
10k+ files to which he added an SPDX license header in the last kernel 
release.

-- 
Regards,

Laurent Pinchart
