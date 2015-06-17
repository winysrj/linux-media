Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40198 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbbFQLCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 07:02:54 -0400
Date: Wed, 17 Jun 2015 08:02:49 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Gabor Z. Papp" <gzpapp.lists@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx problem with 3.10-4.0
Message-ID: <20150617080249.379eeb10@recife.lan>
In-Reply-To: <x6oakedev9@gzp>
References: <x6d212hdgj@gzp>
	<x6d20wi1ml@gzp>
	<20150616062056.34b4d4ef@recife.lan>
	<x6oakedev9@gzp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2015 08:32:26 +0200
"Gabor Z. Papp" <gzpapp.lists@gmail.com> escreveu:

> * Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> 
> | Nothing. You just ran out of continuous memory. This driver
> | requires long chunks of continuous memory for USB data transfer.
> 
> And there is no way to preset some mem?
> Or do something to get the driver work again?
> I don't think I'm using too much memory.
> 
> $ free
>              total       used       free     shared    buffers     cached
> Mem:       2073656     625696    1447960          0      21072     231096
> -/+ buffers/cache:     373528    1700128
> Swap:      1004056          0    1004056

>From your error logs, it failed to allocate the 3rd buffer (of a total of 5
buffers) with a continuous block of 165.120 bytes on the DMA range.

In order words, your system needs to have at least 5 non-fragmented buffers
with 256KB each, on a memory region where the CPU can do DMA (e. g. 
outside the high memory area).

I'm not a memory management specialist, but I guess you could try to change
some sysctl parameters or use a different memory allocator in order to avoid
memory fragmentation.

If you're a C programmer, an option would be to change the driver's code
to optimize it for low memory usage, for example, to reduce the buffer size
and increasing the number of buffers (at the cost of requiring more CPU
and/or reducing the maximum size of the image). Another alternative would be
to reserve the memory at the time the driver gets loaded.

Regards,
Mauro
