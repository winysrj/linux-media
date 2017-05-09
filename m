Return-path: <linux-media-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:32810 "EHLO
        gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753210AbdEININ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 09:08:13 -0400
Date: Tue, 9 May 2017 15:01:47 +0200
From: Lennart Poettering <lennart@poettering.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: systemd-devel@lists.freedesktop.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [systemd-devel] [PATCH] 50-udev-default.rules.in: set correct
 group for mediaX/cecX
Message-ID: <20170509130147.GA29386@gardel-login>
References: <072f4734-5636-7a9d-2151-5fb95e48a262@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <072f4734-5636-7a9d-2151-5fb95e48a262@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 09.05.17 09:40, Hans Verkuil (hverkuil@xs4all.nl) wrote:

> The /dev/mediaX and /dev/cecX devices belong to the video group.
> Add two default rules for that.
> 
> The /dev/cecX devices were introduced in kernel 4.8 in staging and moved
> out of staging in 4.10. These devices support the HDMI CEC bus.
> 
> The /dev/mediaX devices are much older, but because they are not used very
> frequently nobody got around to adding this rule to systemd. They let the
> user control complex media pipelines.

Next time, please submit patches as PRs on github. I created one for
your patch now:

https://github.com/systemd/systemd/pull/5921

patch looks good btw.

Lennart

-- 
Lennart Poettering, Red Hat
