Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40497 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaKHL0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 06:26:44 -0500
Received: by mail-lb0-f177.google.com with SMTP id u10so632821lbd.22
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 03:26:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415350234-9826-8-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl> <1415350234-9826-8-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sat, 8 Nov 2014 20:19:39 +0900
Message-ID: <CAMm-=zA9oeVbi6DR3gpZhM5V+psCySJj6EnWDjj+eMUgp2hLQA@mail.gmail.com>
Subject: Re: [RFCv5 PATCH 07/15] vb2: replace 'write' by 'dma_dir'
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Nov 7, 2014 at 5:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The 'write' argument is very ambiguous. I first assumed that if it is 1,
> then we're doing video output but instead it meant the reverse.
>
> Since it is used to setup the dma_dir value anyway it is now replaced by
> the correct dma_dir value which is unambiguous.

Do we need the first patch adding write then? Maybe we could squash
somehow and redo the series please?

-- 
Best regards,
Pawel Osciak
