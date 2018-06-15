Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:44256 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755899AbeFONBk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 09:01:40 -0400
Received: by mail-yb0-f195.google.com with SMTP id w74-v6so3460484ybe.11
        for <linux-media@vger.kernel.org>; Fri, 15 Jun 2018 06:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20180613140714.1686-1-maxime.ripard@bootlin.com>
 <20180613140714.1686-2-maxime.ripard@bootlin.com> <9c80de4e-c070-1051-2089-2d53826c6fc7@xs4all.nl>
In-Reply-To: <9c80de4e-c070-1051-2089-2d53826c6fc7@xs4all.nl>
From: Guenter Roeck <groeck@google.com>
Date: Fri, 15 Jun 2018 06:01:28 -0700
Message-ID: <CABXOdTdrXiseyjS_aWwbiAWW9F4gcQbRsK-KCkUVub82dBtZvA@mail.gmail.com>
Subject: Re: [PATCH 1/9] CHROMIUM: v4l: Add H264 low-level decoder API
 compound controls.
To: hverkuil@xs4all.nl
Cc: maxime.ripard@bootlin.com, hans.verkuil@cisco.com,
        acourbot@chromium.org, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com,
        Tomasz Figa <tfiga@chromium.org>, posciak@chromium.org,
        paul.kocialkowski@bootlin.com, wens@csie.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com, thomas.petazzoni@bootlin.com,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 15, 2018 at 5:00 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 13/06/18 16:07, Maxime Ripard wrote:
> > From: Pawel Osciak <posciak@chromium.org>
>
> Obviously this needs a proper commit message.
>
> >
> > Signed-off-by: Pawel Osciak <posciak@chromium.org>
> > Reviewed-by: Wu-cheng Li <wuchengli@chromium.org>
> > Tested-by: Tomasz Figa <tfiga@chromium.org>
> > [rebase44(groeck): include linux/types.h in v4l2-controls.h]

That internal note should go away.

Guenter
