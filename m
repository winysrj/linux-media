Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41727 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZKZXuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 18:50:55 -0500
Date: Thu, 26 Nov 2009 15:50:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126235057.GG6936@core.coreip.homeip.net>
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com> <4B0E889C.9060405@redhat.com> <4B0EBBB5.5090303@wilsonet.com> <4B0EBF99.1070404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0EBF99.1070404@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 26, 2009 at 03:49:13PM -0200, Mauro Carvalho Chehab wrote:
> 
> Dmitry,
> 
> While lirc is basically a series of input drivers, considering that they have lots
> in common with the input drivers at V4L/DVB and that we'll need to work on
> some glue to merge both, do you mind if I add the lirc drivers at drivers/staging from
> my trees? 
> 

Mauro,

I would not mind if you will be pushing it to staging, however I am not
sure we have an agreement on what exactly the interface that we will be
using. I would hate to get something in that will need to be reworked
again.

Thanks.

-- 
Dmitry
