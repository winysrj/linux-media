Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35629 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbZGSNxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 09:53:13 -0400
Date: Sun, 19 Jul 2009 10:53:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Brian Johnson <brijohn@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] gspca sn9c20x subdriver rev3
Message-ID: <20090719105301.3ddb2f14@pedra.chehab.org>
In-Reply-To: <20090719111145.50db44ee@free.fr>
References: <1247976652-17031-1-git-send-email-brijohn@gmail.com>
	<20090719111145.50db44ee@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 19 Jul 2009 11:11:45 +0200
Jean-Francois Moine <moinejf@free.fr> escreveu:

> On Sun, 19 Jul 2009 00:10:50 -0400
> Brian Johnson <brijohn@gmail.com> wrote:
> 
> > Ok this one just has the following minor changes:
> > 
> > * operations set/get_register in the sd descriptor only exist if
> > CONFIG_VIDEO_ADV_DEBUG is defined
> > * use lowercase letters in hexidecimal notation
> > * add new supported webcams to
> > linux/Documentation/video4linux/gspca.txt
> > * check for NULL after kmalloc when creating jpg_hdr
> 
> Hello, Brian and Mauro,
> 
> I got the patches and sent a pull request. The changesets have a high
> priority.
> 
> I just fixed a compilation warning issued when USB_GSPCA_SN9C20X_EVDEV
> was not set.
> 
> Mauro, I could not update the maintainers list. Do you want Brian sends
> a new patch for that?

Yes. Please send your acked-by: after his patch



Cheers,
Mauro
