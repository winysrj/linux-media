Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f170.google.com ([209.85.167.170]:37081 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbeKYCIs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Nov 2018 21:08:48 -0500
Received: by mail-oi1-f170.google.com with SMTP id y23so12170987oia.4
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2018 07:20:09 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5DP8JEMfjXJ8Hihm684+3=pOoCo1Gz7kt-TnCB7h-8EvA@mail.gmail.com>
 <1542904065.16720.2.camel@pengutronix.de> <CAOMZO5CRWC1qbYa3wAYfd+_ig0s9Bq2Z8Hz1SmM95Zuxb6LqRw@mail.gmail.com>
 <5d63d8ba-94d5-ffb6-cd7c-3217138c5ad4@gmail.com>
In-Reply-To: <5d63d8ba-94d5-ffb6-cd7c-3217138c5ad4@gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Sat, 24 Nov 2018 13:20:04 -0200
Message-ID: <CAOMZO5B0kCjij-=bHGgeFWrqDK-svxD+th42CHMnqKLo5uMP-Q@mail.gmail.com>
Subject: Re: 'bad remote port parent' warnings
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Fri, Nov 23, 2018 at 8:37 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:

> Yes, this is a regression caused by the imx subdev notifier patches.
> I've already sent a patch to the list for this, see
>
> https://www.spinics.net/lists/linux-media/msg141809.html

Thanks, this fixes it.

Hopefully it will be applied as a fix for 4.20.

Thanks
