Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33274 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbbGTIih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 04:38:37 -0400
Received: by ietj16 with SMTP id j16so113043759iet.0
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 01:38:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55ACAA20.3020204@xs4all.nl>
References: <55ACAA20.3020204@xs4all.nl>
Date: Mon, 20 Jul 2015 11:38:36 +0300
Message-ID: <CALi4nhozNVmzqDgkEBFew9x3y4YKNEhb_TLVCr=ZtBv6z25zqw@mail.gmail.com>
Subject: Re: [PATCH] v4l2-mem2mem: drop lock in v4l2_m2m_fop_mmap
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <kamil@wypas.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2015-07-20 10:58 GMT+03:00 Hans Verkuil <hverkuil@xs4all.nl>:
>
> Since vb2_fop_mmap doesn't take the lock, neither should v4l2_m2m_fop_mmap.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
[snip]

Tested-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>


-- 
W.B.R, Mikhail.
