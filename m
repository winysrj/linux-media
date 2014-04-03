Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:58084 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaDCMQx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 08:16:53 -0400
Received: by mail-oa0-f42.google.com with SMTP id i4so1826712oah.15
        for <linux-media@vger.kernel.org>; Thu, 03 Apr 2014 05:16:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140402192651.7c9e3a74@samsung.com>
References: <20140402192651.7c9e3a74@samsung.com>
Date: Thu, 3 Apr 2014 14:16:51 +0200
Message-ID: <CA+2YH7u0YgEcH_0WYFwEhX7dj09aayMe+YpubHUY5eXrQH=D4g@mail.gmail.com>
Subject: Re: [ANNOUNCE] git web interface was changed to cgit
From: Enrico <ebutera@users.berlios.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 3, 2014 at 12:26 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Hi all,
>
> I changed today our git web interface from gitweb to cgit, due to seveal
> reasons:
> ...
> Please ping me if you fin any problems on it.

http://git.linuxtv.org/cgit.cgi/media_build.git/tree/README

the first time i opened that link i got an internal server error, then
it shows an "empty" file (many lines, all empty).

It seems to happen for every file, even in other repos:

http://git.linuxtv.org/cgit.cgi/linux.git/tree/README

Enrico
