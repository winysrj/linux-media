Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZDVXUx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 19:20:53 -0400
Date: Wed, 22 Apr 2009 20:20:50 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: <gregkh@suse.de>
Cc: mfuzzey@gmail.com, gregkh@suse.de, greg@kroah.com,
	linux-media@vger.kernel.org
Subject: Re: patch
 usb-pwc-do-not-pass-stack-allocated-buffers-to-usb-core.patch added to
 gregkh-2.6 tree
Message-ID: <20090422202050.6526c406@pedra.chehab.org>
In-Reply-To: <12404340242540@kroah.org>
References: <20090421194808.8272.8437.stgit@mfuzzey-laptop>
	<12404340242540@kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Apr 2009 14:00:24 -0700
<gregkh@suse.de> wrote:

> 
> This is a note to let you know that I've just added the patch titled
> 
>     Subject: USB: pwc : do not pass stack allocated buffers to USB core.
> 
> to my gregkh-2.6 tree.  Its filename is
> 
>     usb-pwc-do-not-pass-stack-allocated-buffers-to-usb-core.patch
> 
> This tree can be found at 
>     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> 
> 
> From mfuzzey@gmail.com  Wed Apr 22 13:31:46 2009
> From: Martin Fuzzey <mfuzzey@gmail.com>
> Date: Tue, 21 Apr 2009 21:48:09 +0200
> Subject: USB: pwc : do not pass stack allocated buffers to USB core.
> To: Greg KH <greg@kroah.com>, <linux-media@vger.kernel.org>
> Message-ID: <20090421194808.8272.8437.stgit@mfuzzey-laptop>
> 
> 
> This is causes problems on platforms that have alignment requirements
> for DMA transfers.
> 
> Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro
