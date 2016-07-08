Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:53749 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755002AbcGHNKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 09:10:08 -0400
Subject: Re: [PATCH 00/54] Second series of ReST convert patches for media
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2f32dab6-6b09-0181-0be5-a6f20462006f@xs4all.nl>
Date: Fri, 8 Jul 2016 15:10:02 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2016 03:02 PM, Mauro Carvalho Chehab wrote:
> That's the second series of patches related to DocBook to ReST
> conversion. With this patch series, we're ready to merge it
> upstream.
> 
> There are still one thing to do: there are some new updates at
> the DocBook pages on two topic branches (cec and vsp1). Those
> changes should also be converted, in order to be able to remove
> the DocBook pages.
> 
> Visually, I'm more happy with the new pages, as the produced
> layout is more fancy, IMHO, using a modern visual.
> 
> Also, editing ReST pages is a way simpler than editing the
> DocBooks. Also, reviewing documentation patches should be
> simpler, with is a good thing.
> 
> On the bad side, Sphinx doesn't support auto-numberating
> examples, figures or tables. We'll need some extension for
> that. For now, the only impact is on the examples, that were
> manually numerated. So, patches adding new examples will need
> to check and manually renumerate other examples.
> 
> I hope we'll have soon some Sphinx extension to support
> auto-numbering.
> 
> I'll soon change linux.org documentation page to show the
> Sphinx-generated documenation. I intend to keep the old
> one for a while, for people to be able to compare both.
> I'll post an email once I do this at both linux-media and
> linux-doc mailing lists.
> 
> I did a review on all pages, but, as I'm not a Vulcan,
> I'm pretty sure I missed some things. So, feel free to
> review the final document and send me patches with any
> needed fixes or improvements.
> 
> Finally, you'll see some warnings produced by generating
> the documentation.
> 
> There are actually two types of warnings there:
> 
> 1) At least here where I sit, I'm getting those warnings:
> 
> Documentation/linux_tv/media/dvb/fe-diseqc-send-burst.rst:18: WARNING: Error when parsing function declaration:

Can we please put this in Documentation/media instead of linux_tv? That's a really
bad name, and not logical at all since the drivers are all in drivers/media.

Someone looking for the drivers/media documentation won't be able to find it.
I know I had to look in the actual patches to discover that it ended up in linux_tv!

Regards,

	Hans
