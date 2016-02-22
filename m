Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34662 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbcBVUgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 15:36:32 -0500
Received: by mail-ig0-f182.google.com with SMTP id g6so96078904igt.1
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 12:36:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f4d17794d984e8e5bec9f4063ee06bb616294cae.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
	<f4d17794d984e8e5bec9f4063ee06bb616294cae.1456167652.git.mchehab@osg.samsung.com>
Date: Mon, 22 Feb 2016 15:36:31 -0500
Message-ID: <CAOcJUbzUNcMh6Vw08qhcei+uqQ7x_zs7_q4fHtipUDr0SF-GNA@mail.gmail.com>
Subject: Re: [PATCH 3/9] [media] stv0900: avoid going past array
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 22, 2016 at 2:09 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Fix the following smatch warnings:
>         drivers/media/dvb-frontends/stv0900_core.c:1183 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
>         drivers/media/dvb-frontends/stv0900_core.c:1185 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
>         drivers/media/dvb-frontends/stv0900_core.c:1187 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
>         drivers/media/dvb-frontends/stv0900_core.c:1189 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
>         drivers/media/dvb-frontends/stv0900_core.c:1191 stv0900_get_optim_carr_loop() error: buffer overflow 'cllas2' 11 <= 13
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/dvb-frontends/stv0900_core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

This looks reasonable...

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
