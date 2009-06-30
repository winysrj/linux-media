Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2e.orange.fr ([80.12.242.113]:1316 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZF3UjW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 16:39:22 -0400
Message-Id: <200906302040.n5UKewb24176@neptune.localwarp.net>
Date: Tue, 30 Jun 2009 22:40:37 +0200 (CEST)
From: eric.paturage@orange.fr
Reply-To: eric.paturage@orange.fr
Subject: Re: STV06xx and 046d:0840 "Logitech, Inc. QuickCam Express" / "Dexxa
 cam" (inverted colours )
To: erik.andren@gmail.com
cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30 Jun, Erik Andrén wrote:
> 
> Hi,
> The v4l2 format needs to be tweaked.
> Try to replace the line 67 in stv06xx_hdcs.c with the ones below.
> Recompile, retest and report if anyone of these work better.
> V4L2_PIX_FMT_SGBRG8
> V4L2_PIX_FMT_SGRBG8
> V4L2_PIX_FMT_SRGGB8
> 
> Best regards,
> Erik
> 
> 

Hi Erik 

V4L2_PIX_FMT_SGRBG8
does the trick !

 dexxa cam now works with proper colours . 
 Thanks a lot for your help .

Regards 
 
 



