Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0AYMWL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 07:22:11 -0500
Message-ID: <4B5D8CE2.4040505@redhat.com>
Date: Mon, 25 Jan 2010 10:21:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] obsolete config in kernel source (DVB_DIBCOM_DEBUG)
References: <20100115120857.GA3321@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100115120857.GA3321@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Could you please take a look on this patch? It makes sense or to apply it
or to add an option to enable debug messages at the drivers.

Cheers,
Mauro

Christoph Egger wrote:
> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	By this we discovered the config Option DVB_DIBCOM_DEBUG,
> which was dropped while removing the dibusb driver in favor of dvb-usb
> in 2005. However it remaind existant at some places of the kernel
> config.
> 
> 	Probably one should be a bit more agressive here as the dprintk
> macro now expands to a do{}while(0) unconditionally so all blocks
> using them can also be dropped to remove in-tree cruft but the patch
> does a first cleanup.
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.
> 
> Regards
> 
> 	Christoph Egger
> 
> [0] http://vamos1.informatik.uni-erlangen.de/
> 

