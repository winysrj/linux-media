Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbZE0Siw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 14:38:52 -0400
Date: Wed, 27 May 2009 15:38:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: linux-media@vger.kernel.org, phil.lemelin@gmail.com
Subject: Re: Fwd: [Linux-uvc-devel] Compilation error
Message-ID: <20090527153848.1dfb85e7@pedra.chehab.org>
In-Reply-To: <200905270157.55653.laurent.pinchart@skynet.be>
References: <200905270157.55653.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 May 2009 01:57:55 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> escreveu:

> Hi everybody,
> 
> ----------  Forwarded Message  ----------
> 
> Subject: [Linux-uvc-devel] Compilation error
> Date: Tuesday 26 May 2009
> From: Phil Lemelin
> To: linux-uvc-devel@lists.berlios.de
> 
> Hi uvc-devel list,
> 
> I'm trying to get my usb camera to work ( 174f:8a34 Syntek ) on a older
> system ( 2.6.18-6, debian etch ) and I am not able to compile the source
> code found on the HG repository. The error I get is the following :
> 
> >
> > *snip*
> > CC [M]  /home/phil/uvcvideo-b7cdedd8e305/v4l/av7110_hw.o
> > /home/phil/uvcvideo-b7cdedd8e305/v4l/av7110_hw.c:294: error: expected
> > declaration specifiers or '...' before string constant
> > /home/phil/uvcvideo-b7cdedd8e305/v4l/av7110_hw.c:294: warning: data
> > definition has no type or storage class
> > /home/phil/uvcvideo-b7cdedd8e305/v4l/av7110_hw.c:294: warning: type
> > defaults to 'int' in declaration of 'MODULE_FIRMWARE'
> > /home/phil/uvcvideo-b7cdedd8e305/v4l/av7110_hw.c:294: warning: function
> > declaration isn't a prototype
> > make[3]: *** [/home/phil/uvcvideo-b7cdedd8e305/v4l/av7110_hw.o] Error 1
> > make[2]: *** [_module_/home/phil/uvcvideo-b7cdedd8e305/v4l] Error 2
> > make[2]: Leaving directory `/usr/src/linux-headers-2.6.18-6-686'
> > make[1]: *** [default] Error 2
> > make[1]: Leaving directory `/home/phil/uvcvideo-b7cdedd8e305/v4l'
> > make: *** [all] Error 2
> >
> 
> -------------------------------------------------------
> 
> Is an update to v4l/versions.txt needed ?

I just applied a patch at tip that restores compilation with legacy kernels,
tested here with a RHEL5 kernel (a patched version of 2.6.16)



Cheers,
Mauro
