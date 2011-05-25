Return-path: <mchehab@pedra>
Received: from www.youplala.net ([88.191.51.216]:48590 "EHLO mail.youplala.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab1EYWIB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 18:08:01 -0400
Received: from [192.168.1.70] (host86-154-134-160.range86-154.btcentralplus.com [86.154.134.160])
	by mail.youplala.net (Postfix) with ESMTPSA id 4EE36D880B3
	for <linux-media@vger.kernel.org>; Thu, 26 May 2011 00:07:36 +0200 (CEST)
Subject: Re: build errors on kinect and rc-main - 2.6.38 (mipi-csis not
 rc-main)
From: Nicolas WILL <nico@youplala.net>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <9C58F89F-7B1F-4D72-AD30-59AC8E3921A8@wilsonet.com>
References: <1306305788.2390.4.camel@porites>
	 <1306306916.2390.6.camel@porites>
	 <21882CB6-3679-444E-A072-8AAE43610367@wilsonet.com>
	 <9C58F89F-7B1F-4D72-AD30-59AC8E3921A8@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 23:07:31 +0100
Message-ID: <1306361251.2452.0.camel@porites>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-05-25 at 18:02 -0400, Jarod Wilson wrote:
> On May 25, 2011, at 5:41 PM, Jarod Wilson wrote:
> 
> > On May 25, 2011, at 3:01 AM, Nicolas WILL wrote:
> > 
> >> On Wed, 2011-05-25 at 07:43 +0100, Nicolas WILL wrote:
> >>> The second one is on rc-main (I probably need that!):
> >>> 
> >>> CC [M]  /home/nico/src/media_build/v4l/rc-main.o
> >>> /home/nico/src/media_build/v4l/rc-main.c: In function
> 'rc_allocate_device':
> >>> /home/nico/src/media_build/v4l/rc-main.c:993:29: warning:
> assignment from incompatible pointer type
> >>> /home/nico/src/media_build/v4l/rc-main.c:994:29: warning:
> assignment from incompatible pointer type
> >>> CC [M]  /home/nico/src/media_build/v4l/ir-raw.o
> >>> CC [M]  /home/nico/src/media_build/v4l/mipi-csis.o
> >>> /home/nico/src/media_build/v4l/mipi-csis.c:29:28: fatal error:
> plat/mipi_csis.h: No such file or directory
> >>> compilation terminated.
> >> 
> >> Oh, not rc-main, but mipi-csis!
> > 
> > True, but the rc-main warning is actually a valid issue that needs
> to
> > be fixed as well. I'll get the necessary backport patch into
> media_build
> > shortly, I hope...
> 
> Patches pushed. 

:o)

Thanks !

Nico

