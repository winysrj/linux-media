Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38211 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbbKSN0h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 08:26:37 -0500
MIME-Version: 1.0
In-Reply-To: <4284996.N31E5Y01de@wuerfel>
References: <4284996.N31E5Y01de@wuerfel>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 19 Nov 2015 13:26:06 +0000
Message-ID: <CA+V-a8tuUS2x5vdFUZVWvd2C7LiiCQhvpH-zmTsii3uMcJCLmw@mail.gmail.com>
Subject: Re: [PATCH] [media] davinci: add i2c Kconfig dependencies
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 19, 2015 at 12:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> All the davinci media drivers are using the i2c framework, and
> fail to build if that is ever disabled, e.g.:
>
> media/platform/davinci/vpif_display.c: In function 'vpif_probe':
> media/platform/davinci/vpif_display.c:1298:14: error: implicit declaration of function 'i2c_get_adapter' [-Werror=implicit-function-declaration]
>
> This adds explicit Kconfig dependencies so we don't see the
> driver options if I2C is turned off.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
