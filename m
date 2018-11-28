Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:39060 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728775AbeK2EV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:21:59 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wenyou Yang <wenyou.yang@microchip.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] media: don't ifdef v4l2_subdev_get_try_format() any more
Date: Wed, 28 Nov 2018 18:19:12 +0100
Message-Id: <20181128171918.160643-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patch set does a minor cleanup as suggested by Jacopo.
All driver patches (2-6) depend on the first one.

I've just compile-tested most of these as the only actual sensor I have i=
s
the ov7670.

Cheers,
Lubo

In-Reply-To:=20
