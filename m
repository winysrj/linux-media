Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59861 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbbHMIAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 04:00:52 -0400
Message-ID: <55CC4E18.7080605@xs4all.nl>
Date: Thu, 13 Aug 2015 09:58:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>, Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH RFC v3 10/16] media: rename link source/sink to pad0_source/pad1_sink
References: <cover.1439410053.git.mchehab@osg.samsung.com> <30472f0a7f52ee834978c70cbecc5c035ce20f71.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <30472f0a7f52ee834978c70cbecc5c035ce20f71.1439410053.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/15 22:14, Mauro Carvalho Chehab wrote:
> Change the internal namespace for links between two pads to
> have the "pad" there.
> 
> We're also numbering it, as a common constructor is to do
> things like:
> 
>  	if (link->port1.type != MEDIA_GRAPH_PAD)
>  		continue;
>  	if (link->pad1_sink->entity == entity)
> 		/* do something */
> 
> by preserving the number, we keep consistency between
> port1 and pad1_sink, and port0 and pad0_source.

I would really leave this patch out. As long as sink and source are consistently
used for pads (and they are), then I see no benefit at all to this change.

Another reason why I don't like this is that pad0_ and pad1_ are actually
confusing since they suggested to me when I first read it that pad0_ referred to
the pad with index 0 and pad1_ referred to the pad with index 1.

That's obviously not the case, but it does mean that the prefix doesn't really
make things clearer.

I would just stick with source and sink.

Regards,

	Hans
