Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f42.google.com ([209.85.216.42]:37735 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1INGO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 02:14:57 -0400
Received: by qwi4 with SMTP id 4so1766649qwi.1
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 23:14:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109131312370.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<Pine.LNX.4.64.1109130943021.17902@axis700.grange>
	<CAHG8p1AYXg9zHjoYk6H1pGwUnSzmBTvazWDJuco8nQbFkHOtuw@mail.gmail.com>
	<Pine.LNX.4.64.1109131312370.17902@axis700.grange>
Date: Wed, 14 Sep 2011 14:14:56 +0800
Message-ID: <CAHG8p1BSGJ2MDPHXhvS5PyG9MYjbg8GFi17MMCwssVQc-1TX7w@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> > I think, the direct use of vb2_plane_cookie() is discouraged.
>> > vb2_dma_contig_plane_dma_addr() should work for you.
>> >
>> I guess you mean vb2_dma_contig_plane_paddr
>
> no, in the current kernel it's vb2_dma_contig_plane_dma_addr(). See
>
> http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.2
>
my git repo is http://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
branch is v4l_for_linus
Is this the official git repo or in linuxtv.org?
My patch is against 3.1 not 3.2.
