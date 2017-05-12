Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:33098 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751975AbdELEju (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 00:39:50 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: linux-media <linux-media@vger.kernel.org>,
        zhaoxuegang <zhaoxuegang@suntec.net>
Subject: Re: [PATCH] TW686x: Fix OOPS on buffer alloc failure
References: <590ADAB1.1040501@suntec.net> <m3h90thwjt.fsf@t19.piap.pl>
        <m3d1bhhwf3.fsf_-_@t19.piap.pl>
        <CAAEAJfBVOKBcZBg91EKHBXKMOkM6eRafe8=XnW8E=6vtn2dBmQ@mail.gmail.com>
        <m38tm3j0wr.fsf@t19.piap.pl>
        <CAAEAJfAo8-efB-ZopydXFdRZDKsTKcSzx1vkaJwcpDQQ1Eiivw@mail.gmail.com>
Date: Fri, 12 May 2017 06:39:47 +0200
In-Reply-To: <CAAEAJfAo8-efB-ZopydXFdRZDKsTKcSzx1vkaJwcpDQQ1Eiivw@mail.gmail.com>
        (Ezequiel Garcia's message of "Thu, 11 May 2017 13:04:42 -0300")
Message-ID: <m3zieiheng.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:

> How about this one (untested) ?
>
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c
> b/drivers/media/pci/tw686x/tw686x-video.c
> index c3fafa97b2d0..77b8d2dbd995 100644
> --- a/drivers/media/pci/tw686x/tw686x-video.c
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -86,6 +86,9 @@ static void tw686x_memcpy_dma_free(struct
> tw686x_video_channel *vc,
>         struct pci_dev *pci_dev;
>         unsigned long flags;
>
> +       /* Make sure this channel is initialized */
> +       if (!dev)
> +               return;

Whatever you wish. Just make sure it doesn't bomb out by default, when
one happens to have such a card in his or her machine.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
