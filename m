Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61917 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbaJPU12 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 16:27:28 -0400
Date: Thu, 16 Oct 2014 22:27:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/2] media: soc_camera: rcar_vin: Add r8a7794, r8a7793
 device support
In-Reply-To: <1413271224-9792-1-git-send-email-ykaneko0929@gmail.com>
Message-ID: <Pine.LNX.4.64.1410162222550.16927@axis700.grange>
References: <1413271224-9792-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Thanks for the patches. Could you please fold these two into one - they 
really don't deserve to be separated. As for your other series - patches 
there look mostly good - from just a formal review. If you don't mind, 
I'll adjust a couple of cosmetic issues like missing curly braces in 

	if (a)
		x();
	else {
		y();
		z();
	}

or multiline comments or similar minor things.

Thanks
Guennadi

On Tue, 14 Oct 2014, Yoshihiro Kaneko wrote:

> This series is against master branch of linuxtv.org/media_tree.git.
> 
> Koji Matsuoka (2):
>   media: soc_camera: rcar_vin: Add r8a7794 device support
>   media: soc_camera: rcar_vin: Add r8a7793 device support
> 
>  drivers/media/platform/soc_camera/rcar_vin.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> -- 
> 1.9.1
> 
