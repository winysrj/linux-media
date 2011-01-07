Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44766 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab1AGEnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 23:43:23 -0500
Received: by wwi17 with SMTP id 17so114681wwi.1
        for <linux-media@vger.kernel.org>; Thu, 06 Jan 2011 20:43:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294375239-7009-1-git-send-email-pawel@osciak.com>
References: <1294375239-7009-1-git-send-email-pawel@osciak.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 6 Jan 2011 20:43:02 -0800
Message-ID: <AANLkTikz2bvOmqT4qju-xvNKKT56ySdSLCFjQ21VAmFJ@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] Fix mmap() example in the V4L2 API DocBook
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, Pawel Osciak <pawel@osciak.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 6, 2011 at 20:40, Pawel Osciak <pawel@osciak.com> wrote:
> Correct ioctl return value handling and fix coding style issues.
>
> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> ---
>  Documentation/DocBook/v4l/io.xml |   40 +++++++++++++++++++-------------------
>  1 files changed, 20 insertions(+), 20 deletions(-)

This is a standalone patch, there will be no 2/2, sorry for the confusion.

-- 
Best regards,
Pawel Osciak
