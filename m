Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35657 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755229AbcIEP5M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 11:57:12 -0400
MIME-Version: 1.0
In-Reply-To: <4112113.lBOXq3Iuhk@avalon>
References: <20160902134714.12224-1-niklas.soderlund+renesas@ragnatech.se>
 <20160902134714.12224-3-niklas.soderlund+renesas@ragnatech.se> <4112113.lBOXq3Iuhk@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 5 Sep 2016 17:57:11 +0200
Message-ID: <CAMuHMdXLS6FpZB0CkAvO2_oMUCv1q2Lxps2vMp4Ghu43bVQp9w@mail.gmail.com>
Subject: Re: [PATCH 2/2] v4l: vsp1: Add HGT support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Sep 5, 2016 at 5:43 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> +     for (n = 0; n < 6; n++)
>
> Nitpicking, the driver uses pre-increment in for loops (++n), not post-
> increment. This used to be a best-practice rule in C++, where pre-increment
> can be faster for non-native types (see http://antonym.org/2008/05/stl-iterators-and-performance.html for instance). I'm not sure if that's still
> relevant, but I've taken the habit of using the pre-increment operator in for
> loops, and that's what the rest of this driver does. This comment applies to
> all other locations in this file.

<surprised>
Didn't know we used C++ and operator overloading in the kernel...
</surprised>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
