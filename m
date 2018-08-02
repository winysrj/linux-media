Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32963 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732034AbeHBNzC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 09:55:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id d4-v6so1207380pfn.0
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 05:04:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <13de5e62-8c73-7e46-d848-6ae78dde1588@xs4all.nl>
References: <20180801210714.1620-1-ezequiel@collabora.com> <20180801210714.1620-4-ezequiel@collabora.com>
 <13de5e62-8c73-7e46-d848-6ae78dde1588@xs4all.nl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Thu, 2 Aug 2018 09:04:09 -0300
Message-ID: <CAAEAJfD_WDBPAP9ymuc=W2upVGhJJ25WsnhTe6d6zySF5weGxQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: add Rockchip VPU driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 August 2018 at 05:54, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 08/01/18 23:07, Ezequiel Garcia wrote:
>> Add a mem2mem driver for the VPU available on Rockchip SoCs.
>> Currently only JPEG encoding is supported, for RK3399 and RK3288
>> platforms.
>>
>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
[..]
>
> I stop reviewing here since I wonder if this is really the v2 source code=
.
> I see too many things I've commented about in v1. Did you accidentally
> post the v1 again?
>

Yes, that seems to be the case!
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
