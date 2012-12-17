Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61161 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LQPQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 10:16:47 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so4831162lbb.19
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 07:16:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOcJUbzLTOASaHDAgCdFiYtOKoUM4oTEOP3EpbD9EE_zdT2O6w@mail.gmail.com>
References: <CAOcJUbzLTOASaHDAgCdFiYtOKoUM4oTEOP3EpbD9EE_zdT2O6w@mail.gmail.com>
Date: Mon, 17 Dec 2012 10:16:46 -0500
Message-ID: <CAOcJUbzK_CG3p5vcddm5hp02QFOOaw2Nh4LKuqR0HHQJA+0ENA@mail.gmail.com>
Subject: Re: [PULL] au0828: update model matrix | git://linuxtv.org/mkrufky/hauppauge
 voyager-72281
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed on irc, the following pwclient commands should update the
status of the patches in patchwork to correspond with this merge
request:

pwclient update -s 'superseded' 15708
pwclient update -s 'superseded' 15709
pwclient update -s 'superseded' 15710
pwclient update -s 'superseded' 15711
pwclient update -s 'accepted' 15707


Cheers,

Mike

On Wed, Nov 28, 2012 at 10:23 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> The following changes since commit c6c22955f80f2db9614b01fe5a3d1cfcd8b3d848:
>
>   [media] dma-mapping: fix dma_common_get_sgtable() conditional
> compilation (2012-11-27 09:42:31 -0200)
>
> are available in the git repository at:
>
>   git://linuxtv.org/mkrufky/hauppauge voyager-72281
>
> for you to fetch changes up to 72567f3cfafe31c1612efe52e2893e960cc8dd00:
>
>   au0828: update model matrix entries for 72261, 72271 & 72281
> (2012-11-28 09:46:24 -0500)
>
> ----------------------------------------------------------------
> Michael Krufky (2):
>       au0828: add missing model 72281, usb id 2040:7270 to the model matrix
>       au0828: update model matrix entries for 72261, 72271 & 72281
>
>  drivers/media/usb/au0828/au0828-cards.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
