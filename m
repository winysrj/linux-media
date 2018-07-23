Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58395 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388005AbeGWO1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 10:27:30 -0400
Message-ID: <1532352373.3501.10.camel@pengutronix.de>
Subject: Re: [PATCH v2 00/16] i.MX media mem2mem scaler
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Date: Mon, 23 Jul 2018 15:26:13 +0200
In-Reply-To: <38565a74-7c79-1af6-6ed6-b44a20c9266c@gmail.com>
References: <20180719153042.533-1-p.zabel@pengutronix.de>
         <38565a74-7c79-1af6-6ed6-b44a20c9266c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Sun, 2018-07-22 at 11:30 -0700, Steve Longerbeam wrote:
[...]
> To aid in debugging this I created branch 'imx-mem2mem.stevel' in my
> mediatree fork on github. I moved the mem2mem driver to the beginning
> and added a few patches:
> 
> d317a7771c ("gpu: ipu-cpmem: add WARN_ON_ONCE() for unaligned dma buffers")
> b4362162c0 ("media: imx: mem2mem: Use ipu_image_convert_adjust in try 
> format")
> 4758be0cf8 ("gpu: ipu-v3: image-convert: Fix width/height alignment")
> d069163c7f ("gpu: ipu-v3: image-convert: Fix input bytesperline clamp in 
> adjust")
> 
> (feel free to squash some of those if you agree with them for v3).

Thank you, I've squashed them where it made sense:

- "media: imx: mem2mem: Use ipu_image_convert_adjust in try format"
  into "media: imx: add mem2mem device" so it could be merged
  independently,
- "gpu: ipu-v3: image-convert: Fix width/height alignment" into
  "gpu: ipu-v3: image-convert: relax alignment restrictions", which
  itself is squashed together from "gpu: ipu-v3: image-convert: relax
  input alignment restrictions" and "gpu: ipu-v3: image-convert: relax
  output alignment restrictions", and
- "gpu: ipu-v3: image-convert: Fix input bytesperline clamp in adjust"
  into "gpu: ipu-v3: image-convert: fix bytesperline adjustment".

I've added some fixes and limited output tile top/left alignment to 8x8
IRT block size if the rotator is being used, and dropped the current
state into this branch:

  git://git.pengutronix.de/pza/linux imx-mem2mem

regards
Philipp
