Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36124 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965568AbcCOSbI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 14:31:08 -0400
MIME-Version: 1.0
In-Reply-To: <1457995225-1199991-2-git-send-email-arnd@arndb.de>
References: <1457995225-1199991-1-git-send-email-arnd@arndb.de> <1457995225-1199991-2-git-send-email-arnd@arndb.de>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 15 Mar 2016 18:30:37 +0000
Message-ID: <CA+V-a8uPiYmP3n0xF7McpNgHn5qadaJt0hEsyg2MTPzG6J2YGQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] am437x-vfpe: fix typo in vpfe_get_app_input_index
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Benoit Parrot <bparrot@ti.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thanks for the patch.

On Mon, Mar 14, 2016 at 10:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-6 points out an obviously silly comparison in vpfe_get_app_input_index():
>
> drivers/media/platform/am437x/am437x-vpfe.c: In function 'vpfe_get_app_input_index':
> drivers/media/platform/am437x/am437x-vpfe.c:1709:27: warning: self-comparison always evaluats to true [-Wtautological-compare]
>        client->adapter->nr == client->adapter->nr) {
>                            ^~
>
> This was introduced in a slighly incorrect conversion, and it's
> clear that the comparison was meant to compare the iterator
> to the current subdev instead, as we do in the line above.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: d37232390fd4 ("[media] media: am437x-vpfe: match the OF node/i2c addr instead of name")
> ---

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
