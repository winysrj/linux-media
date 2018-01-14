Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37779 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbeANOTG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 09:19:06 -0500
Received: by mail-oi0-f65.google.com with SMTP id e144so6760709oib.4
        for <linux-media@vger.kernel.org>; Sun, 14 Jan 2018 06:19:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1515925303-5160-1-git-send-email-jasmin@anw.at>
References: <1515925303-5160-1-git-send-email-jasmin@anw.at>
From: Arnd Bergmann <arnd@arndb.de>
Date: Sun, 14 Jan 2018 15:19:04 +0100
Message-ID: <CAK8P3a3hY23dH8hS2+UjjeR03M1dP-tQOyXHANiCOHh6WJn9oA@mail.gmail.com>
Subject: Re: [PATCH] media: uvcvideo: Fixed ktime_t to ns conversion
To: "Jasmin J." <jasmin@anw.at>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 14, 2018 at 11:21 AM, Jasmin J. <jasmin@anw.at> wrote:
> From: Jasmin Jessich <jasmin@anw.at>
>
> Commit 828ee8c71950 ("media: uvcvideo: Use ktime_t for timestamps")
> changed to use ktime_t for timestamps. Older Kernels use a struct for
> ktime_t, which requires the conversion function ktime_to_ns to be used on
> some places. With this patch it will compile now also for older Kernel
> versions.
>
> Signed-off-by: Jasmin Jessich <jasmin@anw.at>

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
