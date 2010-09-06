Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35203 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0IFL4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 07:56:49 -0400
Received: by wyf22 with SMTP id 22so2859128wyf.19
        for <linux-media@vger.kernel.org>; Mon, 06 Sep 2010 04:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikpre0t4pc854q6sRC4f-=Qx8DLHfd=ZaVnm8Bf@mail.gmail.com>
References: <AANLkTikpre0t4pc854q6sRC4f-=Qx8DLHfd=ZaVnm8Bf@mail.gmail.com>
From: Joel Wiramu Pauling <joel@aenertia.net>
Date: Mon, 6 Sep 2010 23:56:28 +1200
Message-ID: <AANLkTik_vyuG2bayBuZjCsA_wChUnAyELcJFuHaq-7Uj@mail.gmail.com>
Subject: Re: Some info about the AverTV A835
To: Jordi Verdugo <sagman.staredsi@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

it is an af9035, there are some, buggy and old 3rd party vendor
drivers floating around that had up to 2.6.28 kernel targets in the
make files, and can be hacked to sorta work with .31 kernels.

They are buggy and unstable however, as the af9035 chip and the tuners
that are commonly packaged with it are undocumented and afatech have
stopped playing ball with the community. The old af9015 chip that many
of the vendors who make tunner products were packaging is supported
and has been in mainlive dvb-v4l tree for a while now. These are
getting harder to find tho.

Kind regards

-JoelW

On 6 September 2010 22:02, Jordi Verdugo <sagman.staredsi@gmail.com> wrote:
> Hello all.
>
> I have an Avermedia Volar HD Pro (A835). Since 2 month ago I was
> searching info and news about the support of this device on Linux and
> now I found a spanish forum[0] that seems to explain how you can get
> this device working. I will try it with my AverTV, but my device its
> the Pro model and have the following ID:
> ID 07ca:a835 AVerMedia Technologies, Inc.
>
> Someone had tried to get working this device? I will try this and I
> will explain soon my experience if i get succesfully working my
> avermedia.
>
> [0] - http://comunidad.fotolibre.net/index.php/topic,5707.msg64719.html#msg64719
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
