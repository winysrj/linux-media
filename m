Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44585 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751621AbZF2KaJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 06:30:09 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken with in-kernel drivers, works with gspcav1
Date: Mon, 29 Jun 2009 12:30:09 +0200
Cc: linux-media@vger.kernel.org
References: <200906281514.10689.PeterHuewe@gmx.de> <200906282250.58652.PeterHuewe@gmx.de> <20090629092541.2be8f020@free.fr>
In-Reply-To: <20090629092541.2be8f020@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291230.09550.PeterHuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag 29 Juni 2009 09:25:41 schrieb Jean-Francois Moine:
> > Any suggestions how I get skype to use the compat wrapper?
> You must export LD_PRELOAD. I use a simple script:
>
> 	#!/bin/sh
> 	export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
> 	exec /usr/bin/skype
Hi,
unfortunately this doesn't work with skype :/

 ~ $ cat startskype.sh
#!/bin/sh
export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
exec /usr/bin/skype
 ~ $ ./startskype.sh
ERROR: ld.so: object '/usr/lib/libv4l/v4l1compat.so' from LD_PRELOAD cannot be 
preloaded: ignored.


seems that I have to stick with my old kernel :/

Peter


