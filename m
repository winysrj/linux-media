Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:53014 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbZIDJYq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2009 05:24:46 -0400
Date: Fri, 4 Sep 2009 11:24:38 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Joe Perches <joe@perches.com>, Brian Johnson <brijohn@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] sn9c20x: Reduce data usage, make functions static
Message-ID: <20090904112438.15890681@tele>
In-Reply-To: <1250820538.29546.5.camel@Joe-Laptop.home>
References: <1250820538.29546.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 20 Aug 2009 19:08:58 -0700
Joe Perches <joe@perches.com> wrote:

> Compiled, not tested, no hardware
> 
> Reduces size of object
> 
> Use s16 instead of int where possible.
	[snip]
> -static const int hsv_red_x[] = {
> +static const s16 hsv_red_x[] = {
> 	41,  44,  46,  48,  50,  52,  54,  56,
> 	58,  60,  62,  64,  66,  68,  70,  72,
> 	74,  76,  78,  80,  81,  83,  85,  87,
	[snip]

Hi Joe and Brian,

I got the patch but I was wondering if such tables could be even
smaller with 's8'?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
