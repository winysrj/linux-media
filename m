Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:53992 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2CTKFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:05:55 -0400
Message-ID: <4F6856C0.4070404@matrix-vision.de>
Date: Tue, 20 Mar 2012 11:06:56 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media ML <linux-media@vger.kernel.org>
Subject: Re: reading config parameters of omap3-isp subdevs
References: <4F6348D7.9070409@matrix-vision.de> <6085689.3CUf0tMs8E@avalon>
In-Reply-To: <6085689.3CUf0tMs8E@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/20/2012 12:22 AM, Laurent Pinchart wrote:
> Hi Michael,
>
> On Friday 16 March 2012 15:06:15 Michael Jones wrote:
[snip]
>
> Adding a R/W bit to the flag argument should indeed work. However, I'm
> wondering what your use case for reading parameters back is.

The simplest use case in my mind is that after the user has fiddled 
around with config parameters, they should be able to set them back to 
their original state.  For that, they need to know what the original 
state was.

 > The preview
> engine parameter structures seem pretty-much self-contained to me, I'm not
> sure it would make sense to only modify one of the parameters.

Why doesn't it make sense to write to only e.g. 'COEF3' in the 
PRV_WBGAIN register?  Especially considering the sparse documentation of 
many of these registers, I would like to be able to tweak the existing 
parameters from their defaults, rather than start from scratch.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
