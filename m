Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZEKWc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 18:32:26 -0400
Date: Mon, 11 May 2009 19:32:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH 1/3 ] increase MPEG encoder timout
Message-ID: <20090511193221.33847738@pedra.chehab.org>
In-Reply-To: <20090428194108.5bd76afd@glory.loctelecom.ru>
References: <20090428194108.5bd76afd@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 28 Apr 2009 19:41:08 +1000
Dmitri Belimov <d.belimov@gmail.com> escreveu:

> Hi All.
> 
> If video has a lot of changes in frame, MPEG encoder need more time for coding process.
> Add new bigger timeout for encoder.
> 
> This is patch from our customer. I checked this.
> 
> Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>

Next time, please sign the patch, since you're forwarding it.



Cheers,
Mauro
