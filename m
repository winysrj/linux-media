Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:49199 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1AQNP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 08:15:56 -0500
Message-ID: <4D344103.2010505@infradead.org>
Date: Mon, 17 Jan 2011 11:15:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix media_build file matching
References: <201101171321.15893.hansverk@cisco.com>
In-Reply-To: <201101171321.15893.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-01-2011 10:21, Hans Verkuil escreveu:
> Hi Mauro,
> 
> Can you apply this patch to the media_build tree? It quotes the *.[ch] file
> pattern used by find.
> 
> When I was experimenting with the media_build tree and trying
> 'make tar DIR=<git repo>' I kept ending up with just one source in my tar
> archive. I couldn't for the life of me understand what was going on until
> I realized that I had a copy of a media driver source in the top dir of my
> git repository. Because the file pattern was not quoted it would expand to
> that particular source and match only that one.
> 
> It took me a surprisingly long time before I figured this out :-(
> 
> Quoting the pattern fixes this.

Applied, thanks!

Cheers,
Mauro
