Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35984 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbcBHKX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 05:23:58 -0500
Received: by mail-io0-f177.google.com with SMTP id g73so190159323ioe.3
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2016 02:23:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B866D9.5070606@xs4all.nl>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	<56938969.30104@xs4all.nl>
	<CAM_ZknVgTETBNXu+8N6eJa=cf_Mmj=+tA=ocKB9SJL5rkSyijQ@mail.gmail.com>
	<56B866D9.5070606@xs4all.nl>
Date: Mon, 8 Feb 2016 12:23:57 +0200
Message-ID: <CAM_ZknVjRo0vo2_SLmZSW7R_8LpNkmj-c3q1uBahEa_bSBK0hQ@mail.gmail.com>
Subject: Re: [RFC PATCH v0] Add tw5864 driver
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrey Utkin <andrey.od.utkin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 8, 2016 at 11:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Andrey,
>
> Hmm, it looks like I forgot to reply. Sorry about that.

Thank you very much anyway.

> I wouldn't change the memcpy: in my experience it is very useful to get a
> well-formed compressed stream out of the hardware. And the overhead of
> having to do a memcpy is a small price to pay and on modern CPUs should
> be barely noticeable for SDTV inputs.

So there's no usecase for scatter-gather approach, right?

> I don't believe that the lockups you see are related to the memcpy as
> such. The trace says that a cpu is stuck for 22s, no way that is related
> to something like that. It looks more like a deadlock somewhere.

There was a locking issue (lack of _irqsave) and was fixed since then.

> Regarding the compliance tests: don't pass VB2_USERPTR (doesn't work well
> with videobuf2-dma-contig). Also add vidioc_expbuf = vb2_ioctl_expbuf for
> the DMABUF support. That should clear up some of the errors you see.

Thank you!

-- 
Bluecherry developer.
