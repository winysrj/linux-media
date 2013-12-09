Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62376 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab3LIBSE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Dec 2013 20:18:04 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so4182446pdj.36
        for <linux-media@vger.kernel.org>; Sun, 08 Dec 2013 17:18:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131113180124.16699fa7@vujade>
References: <20131113180124.16699fa7@vujade>
Date: Sun, 8 Dec 2013 20:18:04 -0500
Message-ID: <CAOcJUbwN_op_NcHAmCamrY+oQRFwm4YfC2SXr7NmGfH15fmm9g@mail.gmail.com>
Subject: Re: [GIT PULL] git://linuxtv.org/mkrufky/dvb cx24117
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Luis Alves <ljalvs@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

What is the status of this pull request?  Patchwork says "changes
requested" but I have no record of any changes requested....

https://patchwork.linuxtv.org/patch/20728/

Thanks,

Mike

On Wed, Nov 13, 2013 at 6:01 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> The following changes since commit
> 80f93c7b0f4599ffbdac8d964ecd1162b8b618b9:
>
>   [media] media: st-rc: Add ST remote control driver (2013-10-31
>   08:20:08 -0200)
>
> are available in the git repository at:
>
>   git://linuxtv.org/mkrufky/dvb cx24117
>
> for you to fetch changes up to 1c468cec3701eb6e26c4911f8a9e8e35cbdebc01:
>
>   cx24117: Fix LNB set_voltage function (2013-11-13 13:06:44 -0500)
>
> ----------------------------------------------------------------
> Luis Alves (2):
>       cx24117: Add complete demod command list
>       cx24117: Fix LNB set_voltage function
>
>  drivers/media/dvb-frontends/cx24117.c | 121
>  ++++++++++++++++++++-------------- 1 file changed, 71 insertions(+),
>  50 deletions(-)
