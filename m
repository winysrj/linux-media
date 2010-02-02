Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab0BBRKX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 12:10:23 -0500
Message-ID: <4B685C77.8080805@redhat.com>
Date: Tue, 02 Feb 2010 15:10:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Subject: Re: [PATCH v3 1/6] V4L - vpfe capture - header files for ISIF driver
References: <1265063238-29072-1-git-send-email-m-karicheri2@ti.com> <1265063238-29072-2-git-send-email-m-karicheri2@ti.com> <1265063238-29072-3-git-send-email-m-karicheri2@ti.com> <4B675FC3.2050505@redhat.com> <A69FA2915331DC488A831521EAE36FE401630F3053@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401630F3053@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan wrote:
> Mauro,
> 
> If you scan the patch, you would see the status of this patch series. 

Ok, but it is not script-able. So, I need to have an easy way to know when
a patch is still under discussion at the ML or if it is ready for merging.

I need something that I can write an script on my machine to update Patchwork
status and remove the stuff that are still under discussions from my pull queue.

On most cases, the level of detail between two revisions of the omap drivers
are due to some intrinsic details of the driver or the arch. So, it makes
no sense for me to keep checking all reviews. I would love to, but unfortunately
I have no spare time for it. That's why I prefer to review only the final revision,
when the patch is submitted.

>>> ---
>>> Applies to linux-next tree of v4l-dvb
>>>  - rebasing to latest for merge (v3)
> 
> Not sure if there is a better way to include this information. The arch part
> of this series requires sign-off from Kevin who is copied on this. I have
> seen your procedure for submitting patches and would send you an official
> pull request as per your procedure once Kevin sign-off the arch part.

The pull request is enough for me. I'll review when I receive it. 

> I have following questions though..
> 
> Should we always add [RFC PATCH] in the subject? It makes sense for
> patches being reviewed. How to request sign-off? Do I only send patches
> to the person, not to the list?

For the patches exchanged via the ML, I need some scriptable way to mark them
as RFC at the Patchwork. 

So, adding [RFC PATCH] or [PATCH RFC] works. It also works if you add something 
like [PATCH OMAP] or [PATCH OMAP V4L], and provided that all other contributors 
to the patches you'll be sending me a pull request do exactly the same.

I'll then write an specific script to mark those patches as RFC and remove from my
queue, until I receive your [PULL] request.

Cheers,
Mauro
