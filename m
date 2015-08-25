Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36403 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbHYWs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 18:48:56 -0400
Received: by iodv127 with SMTP id v127so205385694iod.3
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2015 15:48:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e84fc5863b2f5dd5bc6e5dbdf8d8f77620955a68.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<e84fc5863b2f5dd5bc6e5dbdf8d8f77620955a68.1440359643.git.mchehab@osg.samsung.com>
Date: Tue, 25 Aug 2015 16:48:56 -0600
Message-ID: <CAKocOOMDGbNn_a+y-PmfKv7TgDjdfVoe8Z9QTre8QeQPOV0ZhA@mail.gmail.com>
Subject: Re: [PATCH v7 16/44] [media] media: convert links from array to list
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Antti Palosaari <crope@iki.fi>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Akihiro Tsukada <tskd08@gmail.com>,
	=?UTF-8?Q?Rafael_Louren=C3=A7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 23, 2015 at 2:17 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> The entire logic that represent graph links were developed on a
> time where there were no needs to dynamic remove links. So,
> although links are created/removed one by one via some
> functions, they're stored as an array inside the entity struct.
>
> As the array may grow, there's a logic inside the code that
> checks if the amount of space is not enough to store
> the needed links. If it isn't the core uses krealloc()
> to change the size of the link, with is bad, as it
> leaves the memory fragmented.
>
> So, convert links into a list.
>
> Also, currently,  both source and sink entities need the link
> at the graph traversal logic inside media_entity. So there's
> a logic duplicating all links. That makes it to spend
> twice the memory needed. This is not a big deal for today's
> usage, where the number of links are not big.
>
> Yet, if during the MC workshop discussions, it was said that
> IIO graphs could have up to 4,000 entities. So, we may
> want to remove the duplication on some future. The problem
> is that it would require a separate linked list to store
> the backlinks inside the entity, or to use a more complex
> algorithm to do graph backlink traversal, with is something
> that the current graph traversal inside the core can't cope
> with. So, let's postpone a such change if/when it is actually
> needed.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>

I think it makes sense to add remove  support in phase2 after the
patches 1-15 in this
series that add the graph object and the API changes that go with it
through some
use-cases before adding support for remove.

That way we have confidence in the patch set 1-15 and then we can
build on top with
solid foundation.

thanks,
-- Shuah
