Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64789 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab1IMIl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 04:41:26 -0400
Received: by qyk30 with SMTP id 30so2375481qyk.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 01:41:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109131016010.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<Pine.LNX.4.64.1109131016010.17902@axis700.grange>
Date: Tue, 13 Sep 2011 16:36:19 +0800
Message-ID: <CAHG8p1BhoOB7c5JVcHLkiu-BUzVo1mYDcQ8kvo4frjMiJ7euhQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] v4l2: add vb2_get_unmapped_area in vb2 core
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Hm, wouldn't it be better to use vb2_mmap() and provide a dummy .mmap()
> method in videobuf2-dma-contig.c for the NOMMU case?
>
these are two different file operations called by mm system.
