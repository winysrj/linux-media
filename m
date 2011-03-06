Return-path: <mchehab@pedra>
Received: from smtp-out002.kontent.com ([81.88.40.216]:38111 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1CFQn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 11:43:57 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] [media] dib0700: get rid of on-stack dma buffers
Date: Sun, 6 Mar 2011 17:44:15 +0100
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Greg Kroah-Hartman" <greg@kroah.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <1299410212-24897-1-git-send-email-florian@mickler.org> <201103061606.38846.oliver@neukum.org> <20110306164521.2a88a155@schatten.dmk.lab>
In-Reply-To: <20110306164521.2a88a155@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103061744.15946.oliver@neukum.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Sonntag, 6. März 2011, 16:45:21 schrieb Florian Mickler:

> Hm.. allocating the buffer
> in the probe routine and deallocating it in the usb_driver disconnect
> callback should work?

Yes.
 
> How come that it must be a seperate kmalloc buffer? Is it some aligning
> that kmalloc garantees? 

On some CPUs DMA affects on main CPU, not the CPU caches. You
need to synchronize the cache before you start DMA and must not touch
the buffer until DMA is finished. This applies with a certain granularity
that kmalloc respects. The ugly details are in Documentation.

	Regards
		Oliver
