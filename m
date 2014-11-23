Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:35092 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaKWKZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 05:25:26 -0500
Received: by mail-la0-f48.google.com with SMTP id s18so6212565lam.21
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 02:25:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416315068-22936-5-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-5-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 23 Nov 2014 19:19:21 +0900
Message-ID: <CAMm-=zCxGXZm7g3H4FWiaXGXQBmqu+ELp+xD8ia4Mb+51wGWyQ@mail.gmail.com>
Subject: Re: [REVIEWv7 PATCH 04/12] vb2: don't free alloc context if it is ERR_PTR
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 18, 2014 at 9:51 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Don't try to free a pointer containing an ERR_PTR().
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
