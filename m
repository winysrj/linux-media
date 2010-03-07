Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51509 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754643Ab0CGTpy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Mar 2010 14:45:54 -0500
Date: Sun, 7 Mar 2010 20:45:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Halim Sahin <halim.sahin@t-online.de>
cc: linux-media@vger.kernel.org
Subject: Re: problem compiling modoule mt9t031 in current v4l-dvb-hg
In-Reply-To: <20100307113227.GA8089@gentoo.local>
Message-ID: <Pine.LNX.4.64.1003072045140.4468@axis700.grange>
References: <20100307113227.GA8089@gentoo.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 7 Mar 2010, Halim Sahin wrote:

> Hi Folks,
> I was not able to build v4l-dvb from hg (checked out today).
> 
> 
> /root/work/v4l-dvb/v4l/mt9t031.c:729: error: unknown field 'runtime_suspend' specified in initializer
> /root/work/v4l-dvb/v4l/mt9t031.c:730: error: unknown field 'runtime_resume' specified in initializer
> /root/work/v4l-dvb/v4l/mt9t031.c:730: warning: initialization from incompatible pointer type
> make[3]: *** [/root/work/v4l-dvb/v4l/mt9t031.o] Error 1
> make[2]: *** [_module_/root/work/v4l-dvb/v4l] Error 2
> make[1]: *** [default] Fehler 2
> make: *** [all] Fehler 2
> Kernel 2.6.31 (x86_64)

runtime-pm has been introduced after 2.6.31.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
