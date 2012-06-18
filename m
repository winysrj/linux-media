Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:34776 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2FREUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 00:20:51 -0400
Received: from shed.thedillows.org ([IPv6:2001:470:8:bf8::2])
	by matrix.voodoobox.net (8.13.8/8.13.8) with ESMTP id q5I4Kous024511
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:20:50 -0400
Received: from [192.168.0.10] (obelisk.thedillows.org [192.168.0.10])
	by shed.thedillows.org (8.14.4/8.14.4) with ESMTP id q5I4Knla030942
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:20:49 -0400
Message-ID: <1339993249.32360.44.camel@obelisk.thedillows.org>
Subject: Re: [PATCH 1/2] [media] cx231xx: don't DMA to random addresses
From: David Dillow <dave@thedillows.org>
To: linux-media@vger.kernel.org
Date: Mon, 18 Jun 2012 00:20:49 -0400
In-Reply-To: <1339992921.32360.38.camel@obelisk.thedillows.org>
References: <1339992819.32360.36.camel@obelisk.thedillows.org>
	 <1339992921.32360.38.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-06-18 at 00:15 -0400, David Dillow wrote:
> Commit 7a6f6c29d264cdd2fe0eb3d923217eed5f0ad134 (cx231xx: use
> URB_NO_TRANSFER_DMA_MAP) was intended to avoid mapping the DMA buffer
> for URB twice. This works for the URBs allocated with usb_alloc_urb(),
> as those are allocated from cohernent DMA pools, but the flag was also

Nothing like finding a typo once you've sent a patch out to the wild...

s/cohernent/coherent/

