Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57292
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbcHFU0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2016 16:26:36 -0400
Date: Sat, 6 Aug 2016 09:06:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/3] Add a way to build only media docs
Message-ID: <20160806090631.71331f82@recife.lan>
In-Reply-To: <cover.1470484077.git.mchehab@s-opensource.com>
References: <cover.1470484077.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  6 Aug 2016 09:00:31 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Being able to build just the media docs is important for us due to several
> reasons:
> 
> 1) Media developers community hosts a copy of the media documentation at linuxtv.org
>     with the very latest  under development documents;
> 
> 2) Nitpicking to identify broken references is important to identify documentation gaps
>     that need to be addressed on future releases;
> 
> 3) As media maintainers check patch per patch if a documentation gap is introduced, building
>     media documentation should be as fast as possible.
> 
> This patchset adds a media file adding nitpick support and an extra build target that will
> compile only the media documentation. It also groups all media documentation into one
> section on the main Kernel document, with is, IMHO, a good thing as we start adding more
> stuff there.
> 
> Jon,
> 
> I'd love to see this patch merged early at the -rc cycle, in order to avoid merge
> conflicts when people start converting other docbooks to Sphinx, as it touches
> at the main Makefile and at the Sphinx common stuff. Also, as I'll need to patch my
> build scripts to check for documentation issues with Sphinx, I need them on my
> master branch, as otherwise my workflow will be broken until the next Kernel release.
> 
> So, If you're ok with this patch series, can you submit to Linus on early -rc? Or 
> if you prefer, I can do it myself, with your ack.

Forgot to comment, but those patches are applied against ustream master
branch. I applied them against my development tree at:
	https://git.linuxtv.org//mchehab/experimental.git/log/?h=docs-next

Regards,
Mauro
