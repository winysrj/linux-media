Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60213 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354Ab2DJVm0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 17:42:26 -0400
Received: by obbtb18 with SMTP id tb18so315724obb.19
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 14:42:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+Wt1KzjgggO=ESJ-cBs6Gk5PK0-nazsx52qhW3UUfqNKw@mail.gmail.com>
References: <CALF0-+Wt1KzjgggO=ESJ-cBs6Gk5PK0-nazsx52qhW3UUfqNKw@mail.gmail.com>
Date: Tue, 10 Apr 2012 18:42:25 -0300
Message-ID: <CALF0-+WgpkqDqg1oT_SLuvy12Mmre1MMzQASbkhY_H8jagM0ZA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Make em28xx-input.c a separate module
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/26 Ezequiel García <elezegarcia@gmail.com>:
> Hi,
[snip]
>
>  drivers/media/video/em28xx/Kconfig        |    4 +-
>  drivers/media/video/em28xx/Makefile       |    5 +-
>  drivers/media/video/em28xx/em28xx-cards.c |   66 +--------
>  drivers/media/video/em28xx/em28xx-core.c  |    3 +
>  drivers/media/video/em28xx/em28xx-i2c.c   |    3 -
>  drivers/media/video/em28xx/em28xx-input.c |  250 +++++++++++++++++++----------
>  drivers/media/video/em28xx/em28xx.h       |   32 +----
>  7 files changed, 175 insertions(+), 188 deletions(-)
>
> [1] http://www.spinics.net/lists/linux-media/msg45416.html
>
> Regards,
> Ezequiel.

Hi Mauro,

Is there anything wrong with these?
or is it just too early to ask about them?

Regards,
Ezequiel.
