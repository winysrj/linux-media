Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34454 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbcHVJ1T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:27:19 -0400
MIME-Version: 1.0
In-Reply-To: <f36bf112-d05a-1d61-ca04-f38a1ede75aa@xs4all.nl>
References: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
 <1471530818-7928-11-git-send-email-ricardo.ribalda@gmail.com> <f36bf112-d05a-1d61-ca04-f38a1ede75aa@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 22 Aug 2016 11:26:57 +0200
Message-ID: <CAPybu_3ziKaOtS2JR8CnuO8CSAP4VZREXBn8+Bi+H99nJmKqfA@mail.gmail.com>
Subject: Re: [PATCH v5 10/12] [media] videodev2.h Add HSV encoding
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
        Antti Palosaari <crope@iki.fi>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans:

>
> That should be is_rgb_or_hsv.

Sorry about that! I am resending v5_2 with only that patch fixed

>
> All other patches look OK.

Thanks

>
> It would be useful though if you could rebase on top of https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=sycc.
> I have a pull request outstanding for that tree, and it will conflict with this patch.

It should be already be rebased over that branch:

ricardo@neopili:~/curro/linux-upstream$ git rebase hans/sycc
Current branch vivid-hsv-v5 is up to date.


Best regards!
