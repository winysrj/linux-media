Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:37691 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbeBJOjs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 09:39:48 -0500
Received: by mail-oi0-f49.google.com with SMTP id t78so8170684oih.4
        for <linux-media@vger.kernel.org>; Sat, 10 Feb 2018 06:39:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1b6777bf-3467-2875-baab-505898ff8318@gmail.com>
References: <1518217876-7037-1-git-send-email-festevam@gmail.com> <1b6777bf-3467-2875-baab-505898ff8318@gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 10 Feb 2018 12:39:46 -0200
Message-ID: <CAOMZO5BaovFDY7hRA-DOJmXvr+dc7TsAYf0VnDvdb=ge4Gk4VQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: imx-media-internal-sd: Use empty initializer
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        ian.arkver.dev@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Fri, Feb 9, 2018 at 9:42 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:

> There is one other case of the use of "{0}" to initialize a stack/local
> struct, in prp_enum_frame_size(). It should be fixed there as well, to
> be consistent.

Yes, just sent a patch as you suggested.

Thanks
