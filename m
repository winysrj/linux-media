Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab0BBSBy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 13:01:54 -0500
Message-ID: <4B68688B.80207@redhat.com>
Date: Tue, 02 Feb 2010 16:01:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Subject: Re: [PATCH v3 1/6] V4L - vpfe capture - header files for ISIF driver
References: <1265063238-29072-1-git-send-email-m-karicheri2@ti.com> <1265063238-29072-2-git-send-email-m-karicheri2@ti.com> <1265063238-29072-3-git-send-email-m-karicheri2@ti.com> <4B675FC3.2050505@redhat.com> <A69FA2915331DC488A831521EAE36FE401630F3053@dlee06.ent.ti.com> <4B685C77.8080805@redhat.com> <A69FA2915331DC488A831521EAE36FE401630F31AB@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401630F31AB@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan wrote:
> Mauro,
> 
>>> How to request sign-off? Do I only send patches
>>> to the person, not to the list?
> 
> I think you have not answered this.
>> For the patches exchanged via the ML, I need some scriptable way to mark
>> them
>> as RFC at the Patchwork.
>>
>> So, adding [RFC PATCH] or [PATCH RFC] works. It also works if you add
>> something
>> like [PATCH OMAP] or [PATCH OMAP V4L], and provided that all other
>> contributors
>> to the patches you'll be sending me a pull request do exactly the same.
> 
> 
> Not sure what the last part of your statement (beginning with "provided that") means.

I mean: the better is if everybody sending such patches to do the same way. So, it
would be really good if all traffic at the ML for those RFC patches to have the
same tag.

> The patches always go through multiple iterations. In future
> I will add [RFC PATCH] for such patches. But this request was sent to Kevin
> to ack my patches so that I can send a pull request. How do I handle this?
> A direct email to Kevin without copying to linux-media ?

You don't need to c/c the linux-media ML for it, but, of course you can do it.
Anyway, at the pull requests that are touching on arch, please C/C the arch
maintainer on it (even having their SOB). This will help them to track what's
happening on the files under their responsibility.

-- 

Cheers,
Mauro
