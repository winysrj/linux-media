Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbZFQIeB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 04:34:01 -0400
Date: Wed, 17 Jun 2009 05:33:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How to handle v4l1 -> v4l2 driver transition
Message-ID: <20090617053303.0e29c8b2@pedra.chehab.org>
In-Reply-To: <4A38931C.2060506@redhat.com>
References: <4A38931C.2060506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Jun 2009 08:54:20 +0200
Hans de Goede <hdegoede@redhat.com> escreveu:

> Hi all,
> 
> I've recently been working on adding support for cams with the
> ov511(+) and ov518(+) to the gspca ov519 driver. I'm happy to
> announce that work is finished, see:
> http://linuxtv.org/hg/~hgoede/gspca
> 
> And the pull request I just send. This does lead to the question
> what to do with the existing  in kernel v4l1 ov511 driver, which
> claims to support these 2 bridges too (but since the decompression
> code has been removed actually only works with the 511 in uncompressed
> mode).
> 
> It is clear that the ov518 usb-id's should be removed from the ov511
> driver. But that still leaves the ov511 support, we could just completely
> remove the ov511 driver, as the code in gspca should cover all supported
> devices (and his been tested with a few).
> 
> However the downside of removing it is that people who used to have
> a working ov511 setup now will need to have a (very recent) libv4l
> to keep their setup working.
> 
> So I guess that the best way forward is to mark the driver as deprecated
> now and remove it in say 2 releases?

It seems a good strategy to me, provided that all USB ID's found at the
original ov511 are also present on gspca.

If so, please send the deprecate patch as well. I'll add it on my -git tree.

> 
> Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
