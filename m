Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57026 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2EUMSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 08:18:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 06/10] video/uvc: use memweight()
Date: Mon, 21 May 2012 14:18:16 +0200
Message-ID: <222936460.3TKLPgKfrR@avalon>
In-Reply-To: <CAC5umyiOa=e2DRE3fK=5p6D49uO=QKiQds=sFvQgQ=1osZFgZw@mail.gmail.com>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com> <7559275.nOXNfWAdxV@avalon> <CAC5umyiOa=e2DRE3fK=5p6D49uO=QKiQds=sFvQgQ=1osZFgZw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

On Monday 21 May 2012 21:03:10 Akinobu Mita wrote:
> 2012/5/21 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> > Hi Akinobu,
> > 
> > Thank you for the patch.
> > 
> > On Sunday 20 May 2012 22:23:19 Akinobu Mita wrote:
> >> Use memweight() to count the total number of bits set in memory area.
> >> 
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: linux-media@vger.kernel.org
> > 
> > Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> You meant Acked-by, didn't you?

Oops, yes, sorry. Bad copy & paste.

-- 
Regards,

Laurent Pinchart

