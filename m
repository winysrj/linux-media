Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52992 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755820AbZF2Kye (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 06:54:34 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken with in-kernel drivers, works with gspcav1
Date: Mon, 29 Jun 2009 12:54:34 +0200
Cc: linux-media@vger.kernel.org
References: <200906281514.10689.PeterHuewe@gmx.de> <200906291230.09550.PeterHuewe@gmx.de> <20090629124034.5c43001c@free.fr>
In-Reply-To: <20090629124034.5c43001c@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291254.34727.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag 29 Juni 2009 12:40:34 schrieb Jean-Francois Moine:
> Hi Peter,
>
> Indeed, you are running a 64bits application:
>
> 	#!/bin/sh
> 	export LD_PRELOAD=/usr/lib64/libv4l/v4l1compat.so
> 	exec /usr/bin/skype
>
> Cheers.


Hi :)

/usr/lib is just a link to /usr/lib64 - 
$ ls -lahd /usr/lib
  lrwxrwxrwx 1 root root 5 20. Dez 2008  /usr/lib -> lib64

but I tried it explicitly with both versions:
ERROR: ld.so: object '/usr/lib32/libv4l/v4l1compat.so' from LD_PRELOAD cannot 
be preloaded: ignored.
ERROR: ld.so: object '/usr/lib32/libv4l/v4l1compat.so' from LD_PRELOAD cannot 
be preloaded: ignored.

ERROR: ld.so: object '/usr/lib64/libv4l/v4l1compat.so' from LD_PRELOAD cannot 
be preloaded: ignored.

Seems I have to wait till skype releases a v4l2 compatible skype binary - but 
regarding the development cycle of skype this will be ... ahem ... never :)


Thanks!
Peter

