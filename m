Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0ATPLt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 10:11:49 -0500
Message-ID: <4B571D25.3090505@infradead.org>
Date: Wed, 20 Jan 2010 13:11:33 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Markus Heidelberg <markus.heidelberg@web.de>
CC: Johannes Stezenbach <js@linuxtv.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: [ANNOUNCE] git tree repositories
References: <4B55445A.10300@infradead.org> <20100119112057.GC9187@linuxtv.org> <4B55A915.1000207@infradead.org> <201001200904.44258.markus.heidelberg@web.de>
In-Reply-To: <201001200904.44258.markus.heidelberg@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus Heidelberg wrote:
> Mauro Carvalho Chehab, 2010-01-19:
>> Yes. I personally prefer to have a bare clone (bare trees have just
>> the -git objects, and not a workig tree), and several working copies.
>> I do the work at the working copies, and, after they are fine, I push
>> into the bare and send the branches from bare to upstream.
> 
> Do you know git-new-workdir? It's included in the contrib area of the
> git installation.
> Instead of cloning your own local repository to get a new working
> directory, with this script you really only get a new working directory
> and can work in it as if it was the original clone. Then you don't have
> to deal with pushes between local repositories.

No, I never used. Sometimes, I use to manually create a new workdir copy,
but it is good to know that there's an script ready for doing this.

Thanks for pointing it!

Cheers,
Mauro
