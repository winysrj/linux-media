Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:43246 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaAGNKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:10:38 -0500
Received: by mail-ve0-f180.google.com with SMTP id jz11so79779veb.25
        for <linux-media@vger.kernel.org>; Tue, 07 Jan 2014 05:10:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGj5WxCajB0ORTQ_rz9wv+ec9bXE1A9tM_MGP3qb0eyaxhC5ew@mail.gmail.com>
References: <CAGj5WxCajB0ORTQ_rz9wv+ec9bXE1A9tM_MGP3qb0eyaxhC5ew@mail.gmail.com>
Date: Tue, 7 Jan 2014 18:40:35 +0530
Message-ID: <CAHFNz9KzKdC0xvq7nM6yF0DGQ3pCq7tUr0et-cvf6Wk5Htarxg@mail.gmail.com>
Subject: Re: Upstreaming SAA716x driver to the media_tree
From: Manu Abraham <abraham.manu@gmail.com>
To: Luis Alves <ljalvs@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Andreas Regel <andreas.regel@gmx.de>,
	Chris Lee <updatelee@gmail.com>, crazycat69@narod.ru,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luis,


On Tue, Jan 7, 2014 at 5:28 PM, Luis Alves <ljalvs@gmail.com> wrote:
> Hi,
>
> I'm finishing a new frontend driver for one of my dvb cards, but the
> pcie bridge uses the (cursed) saa716x.
> As far as I know the progress to upstream Manu's driver to the
> media_tree has stalled.
>
> In CC I've placed some of the people that I found working on it
> lately, supporting a few dvb cards.
>
> It would be good if we could gather everything in one place and send a
> few patchs to get this upstreamed for once...
>
> Manu, do you see any inconvenience in sending your driver to the
> linux_media tree?
> I'm available to place some effort on this task.


I can push the 716x driver and whatever additional changes that I have
later on this weekend, if that's okay with you.


Regards,

Manu
