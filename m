Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f182.google.com ([209.85.215.182]:46036 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbeKZCIo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 21:08:44 -0500
Received: by mail-pg1-f182.google.com with SMTP id y4so4958496pgc.12
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2018 07:17:27 -0800 (PST)
MIME-Version: 1.0
References: <20181124220323.13497-1-matt.ranostay@konsulko.com>
In-Reply-To: <20181124220323.13497-1-matt.ranostay@konsulko.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Mon, 26 Nov 2018 00:17:16 +0900
Message-ID: <CAC5umyghFPYH=XDZyiw3GT-rB6VKqa9gcQPV-7pSUP3Y+FJ=5w@mail.gmail.com>
Subject: Re: [PATCH v3] media: video-i2c: check if chip struct has set_power function
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B411=E6=9C=8825=E6=97=A5(=E6=97=A5) 7:03 Matt Ranostay <matt.ran=
ostay@konsulko.com>:
>
> Not all future supported video chips will always have power management
> support, and so it is important to check before calling set_power() is
> defined.
>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>

Looks good.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
