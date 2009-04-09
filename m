Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935691AbZDIPs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 11:48:28 -0400
Date: Thu, 9 Apr 2009 12:48:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: rvf16 <rvf16@yahoo.gr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Multiple em28xx devices
Message-ID: <20090409124810.6c9f73bb@pedra.chehab.org>
In-Reply-To: <412bdbff0904090839v43772f6dk7f2ac47ef417f45f@mail.gmail.com>
References: <49DE0891.9010506@yahoo.gr>
	<412bdbff0904090839v43772f6dk7f2ac47ef417f45f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 9 Apr 2009 11:39:47 -0400
Devin Heitmueller <devin.heitmueller@gmail.com> wrote:

> 2009/4/9 rvf16 <rvf16@yahoo.gr>:
> > So does the upstream driver support all the rest ?
> > Analog TV
> Yes
> 
> > FM radio
> No

Yes, it does support FM radio, provided that you proper add radio specific
configuration at em28xx-cards.c.

Cheers,
Mauro
