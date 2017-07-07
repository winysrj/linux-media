Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:34370 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752378AbdGGNik (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 09:38:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAD6G_RQ-7uwTVLr27UTSvA50rLq-yRRTYKMmYQf7K1O8wf6HOA@mail.gmail.com>
References: <CAD6G_RQ-7uwTVLr27UTSvA50rLq-yRRTYKMmYQf7K1O8wf6HOA@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 7 Jul 2017 10:38:38 -0300
Message-ID: <CAOMZO5DTgtgcG_e+Z56fOwAiK4bqmPfBesgZwqUHWzCGZhAZSg@mail.gmail.com>
Subject: Re: coda 2040000.vpu: firmware request failed
To: Jagan Teki <jagannadh.teki@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Trimarchi <michael@amarulasolutions.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jagan,

On Fri, Jul 7, 2017 at 9:45 AM, Jagan Teki <jagannadh.teki@gmail.com> wrote:
> Hi,
>
> I'm observing firmware request failure with i.MX6Q board, This is with
> latest linux-next (4.12) with firmware from, [1] and converted
> v4l-coda960-imx6q.bin using [2].

There is no need to do the conversion with current code.
