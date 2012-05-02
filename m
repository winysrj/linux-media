Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41049 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2EBLPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 07:15:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org
Subject: Re: OMAP3 previewer bayer pattern selection
Date: Wed, 02 May 2012 13:15:37 +0200
Message-ID: <3183330.bDB7oJcFEp@avalon>
In-Reply-To: <CAGGh5h01=YdRtmhe1pXpvmXSPP5e1UPBtqGbN3c2tTbjdmEtVw@mail.gmail.com>
References: <CAGGh5h01=YdRtmhe1pXpvmXSPP5e1UPBtqGbN3c2tTbjdmEtVw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

On Monday 30 April 2012 12:23:27 jean-philippe francois wrote:
> Hi,
> 
> I am trying to get a working preview from a CMOS sensor with a CFA bayer
> pattern.
> 
> Does the CCDC_COLPTN register have any effect on previewer CFA interpolation
> ?

No it doesn't. The CCDC COLPTN register only affects CCDC operation.

> From my experience it does not. I can set BGGR or GRBG, but the output is
> always the same. When doing raw capture, I get nice image if I use a BGGR
> pattern for my software bayer to rgb interpolation. When using previewer,
> the output looks like BGGR interpreted as GRBG, ie blue and red are green,
> and green turns into purple.
> 
> Looking at the driver code (mainline), there is nothing about bayer order
> in the previewer code. Looking at the TRM, theres is also nothing in the
> previewer part about bayer order.
> 
> How are we supposed to debayer something different from GRBG ? By modifying
> the cfa_coef_table table ? Cropping at the previewer output to start on an
> odd line ?

Selecting the CFA pattern requires modifying several registers:

- PCR:CFA_FMT

0x0: Mode 0: conventional Bayer.
0x1: Mode 1: horizontal 2x downsample.
0x2: Mode 2: bypass CFA stage (RGB Foveon X3)
0x3: Mode 3: horizontal and vertical 2x downsample.
0x4: Mode 4: Super CCD Honeycom movie mode sensor.
0x5: Mode5: bypass CFA stage (RRRR GGGG BBBB Foveon X3).

The default value is Bayer, you won't need to change that.

- WBSEL

This register selects which white balance coefficient is applied to which 
pixel. This needs to match the Bayer pattern.

- CFA table

That's where the bulk of the work will be. The CFA coefficients table needs to 
be adjusted based on the Bayer pattern. Unfortunately the publicly available 
TRM doesn't document how the table should be computed.

> Thank you for any pointer on this issue.

-- 
Regards,

Laurent Pinchart

