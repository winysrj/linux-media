Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35128 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbbCGXPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 18:15:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for v4.1] smiapp DT u64 property workaround removal
Date: Sun, 08 Mar 2015 01:15:38 +0200
Message-ID: <1573085.ZVIDUf0yP4@avalon>
In-Reply-To: <20150307220634.GD6539@valkosipuli.retiisi.org.uk>
References: <20150307220634.GD6539@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 08 March 2015 00:06:34 Sakari Ailus wrote:
> Hi Mauro,
> 
> This pull request reverts the smiapp driver's u64 array DT property read
> workaround, and uses of_property_read_u64_array() (second patch) which is
> the correct API function for reading u64 arrays from DT.
> 
> Please pull.
> 
> 
> The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:
> 
>   [media] mn88473: simplify bandwidth registers setting code (2015-03-03
> 13:09:12 -0300)
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/sailus/media_tree.git smiapp-dt
> 
> for you to fetch changes up to 5f36db86e0cbb48c102fee8a3fe2b98a33f13199:
> 
>   smiapp: Use of_property_read_u64_array() to read a 64-bit number array
> (2015-03-08 00:00:20 +0200)
> 
> ----------------------------------------------------------------
> Sakari Ailus (2):
>       Revert "[media] smiapp: Don't compile of_read_number() if CONFIG_OF
> isn't defined"
>       smiapp: Use of_property_read_u64_array() to read a 64-bit number array

Won't this cause a bisection breakage if CONFIG_OF isn't enabled ?

>  drivers/media/i2c/smiapp/smiapp-core.c |   28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)

-- 
Regards,

Laurent Pinchart

