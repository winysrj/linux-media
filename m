Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:63903 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbeHXPpZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 11:45:25 -0400
Date: Fri, 24 Aug 2018 14:05:22 +0200
From: Helmut Grohne <helmut.grohne@intenta.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: aptina-pll: allow approximating the requested
 pix_clock
Message-ID: <20180824120522.3hwtmgztyhprzj3r@laureti-dev>
References: <20180814084026.be4fpbhrppdnx2a3@laureti-dev>
 <20180823075208.mqjctv4ax4dakfws@laureti-dev>
 <20180823113012.u4dm4zbulpksemdi@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20180823113012.u4dm4zbulpksemdi@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for taking the time to look into the issue.

On Thu, Aug 23, 2018 at 01:30:12PM +0200, Sakari Ailus wrote:
> Knowing the formula, the limits as well as the external clock frequency, it
> should be relatively straightforward to come up with a functional pixel
> clock value. Was there a practical problem in coming up with such a value?

I've added a concrete example to my other reply and should have done
that with posting the initial question. I'm sorry for not having done it
earlier.

> You can't pick a value at random; it needs to be one that actually works.
> The purpose of having an exact frequency is that the typical systems where
> these devices are being used, as I explained earlier, is that having a
> random frequency, albeit with which the sensor could possibly work, the
> other devices in the system may not do so.

We already refuted the concept of an "exact frequency". In nature, it
simply isn't exact. Every board will have a slightly different
frequency no matter how precise you calculate it.

I'm not after random frequencies in any case. The goal of course is to
approximate the requested frequency as good as possible. In particular,
when the requested pix_clock allows using a parameter set that attains
the frequency exactly, that parameter set will be emitted rather than
some other approximation. Only for parameters where the old algorithm
returns -EINVAL there should be an observable difference.

Using an exact frequency is difficult here. How am I supposed to write
e.g. 74242424.24242424... Hz into the device tree?

Helmut
