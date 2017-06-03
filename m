Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35414 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750836AbdFCITB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Jun 2017 04:19:01 -0400
Date: Sat, 3 Jun 2017 11:18:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ajay kumar <ajaynumb@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: Support for RGB/YUV 10, 12 BPC(bits per color/component) image
 data formats in kernel
Message-ID: <20170603081817.GQ1019@valkosipuli.retiisi.org.uk>
References: <CAEC9eQNW1hHrn2p9Tu-WR3Kft62x71383HjwbJQSiq_iWebsnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEC9eQNW1hHrn2p9Tu-WR3Kft62x71383HjwbJQSiq_iWebsnw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ajay,

On Fri, Jun 02, 2017 at 06:38:53PM +0530, Ajay kumar wrote:
> Hi all,
> 
> I have tried searching for RGB/YUV 10, 12 BPC formats in videodev2.h,
> media-bus-format.h and drm_fourcc.h
> I could only find RGB 10BPC support in drm_fourcc.h.
> I guess not much support is present for formats with (BPC > 8) in the kernel.

What's "BPC"? Most YUV and RGB formats have only 8 bits per sample. More
format definitions may be added if there's a driver that makes use of them.

> 
> Are there any plans to add fourcc defines for such formats?
> Also, I wanted to how to define fourcc code for those formats?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
