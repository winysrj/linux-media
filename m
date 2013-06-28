Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3F1Rz2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 13:55:28 -0400
Date: Fri, 28 Jun 2013 14:54:58 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] usbtv: fix dependency
Message-ID: <20130628145458.271fd9d8.mchehab@redhat.com>
In-Reply-To: <20130628105515.0f2a3571.mchehab@redhat.com>
References: <201306281024.15428.hverkuil@xs4all.nl>
	<201306281318.44880.hverkuil@xs4all.nl>
	<20130628094246.555bb203.mchehab@redhat.com>
	<201306281459.10398.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1306281521460.29767@axis700.grange>
	<20130628105515.0f2a3571.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Jun 2013 10:55:15 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> > This patch
> > 
> > http://git.linuxtv.org/gliakhovetski/v4l-dvb.git/commitdiff/a92d0222c693db29a5d00eaedcdebf748789c38e
> > 
> > has been pushed 3 days ago:
> > 
> > https://patchwork.linuxtv.org/patch/19090/
> 
> As, according with:
> 	https://lwn.net/Articles/556034/rss
> 
> -rc7 is likely the last one before 3.10, that means that the media merge
> window for 3.11 is closed already (as we close it one week before, in order
> to give more time for reviewing the patches better at -next).
> 
> So, please split the fix patches from it on a separate pull request.

Hmm... just took a look at the actual pull request... from the description,
it seems to contain just fixes/documentation, so, I'll be handling it
in a few.

Regards,
Mauro
-- 

Cheers,
Mauro
