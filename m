Return-path: <mchehab@pedra>
Received: from www.youplala.net ([88.191.51.216]:46734 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1EYHCa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 03:02:30 -0400
Received: from [192.168.1.70] (host86-154-134-160.range86-154.btcentralplus.com [86.154.134.160])
	by mail.youplala.net (Postfix) with ESMTPSA id D74C9D880B3
	for <linux-media@vger.kernel.org>; Wed, 25 May 2011 09:02:03 +0200 (CEST)
Subject: Re: build errors on kinect and rc-main - 2.6.38 (mipi-csis not
 rc-main)
From: Nicolas WILL <nico@youplala.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1306305788.2390.4.camel@porites>
References: <1306305788.2390.4.camel@porites>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 08:01:56 +0100
Message-ID: <1306306916.2390.6.camel@porites>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-05-25 at 07:43 +0100, Nicolas WILL wrote:
> The second one is on rc-main (I probably need that!):
> 
>   CC [M]  /home/nico/src/media_build/v4l/rc-main.o
> /home/nico/src/media_build/v4l/rc-main.c: In function 'rc_allocate_device':
> /home/nico/src/media_build/v4l/rc-main.c:993:29: warning: assignment from incompatible pointer type
> /home/nico/src/media_build/v4l/rc-main.c:994:29: warning: assignment from incompatible pointer type
>   CC [M]  /home/nico/src/media_build/v4l/ir-raw.o
>   CC [M]  /home/nico/src/media_build/v4l/mipi-csis.o
> /home/nico/src/media_build/v4l/mipi-csis.c:29:28: fatal error: plat/mipi_csis.h: No such file or directory
> compilation terminated.

Oh, not rc-main, but mipi-csis!

Sorry...

Nico

