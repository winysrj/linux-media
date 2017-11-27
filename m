Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:51166 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752609AbdK0TIP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 14:08:15 -0500
Date: Mon, 27 Nov 2017 19:07:58 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        y2038@lists.linaro.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] [media] staging: atomisp: convert timestamps to
 ktime_t
Message-ID: <20171127190758.293f11ad@alans-desktop>
In-Reply-To: <20171127152256.2184193-1-arnd@arndb.de>
References: <20171127152256.2184193-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Nov 2017 16:21:41 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> timespec overflows in 2038 on 32-bit architectures, and the
> getnstimeofday() suffers from possible time jumps, so the
> timestamps here are better done using ktime_get(), which has
> neither of those problems.
> 
> In case of ov2680, we don't seem to use the timestamp at
> all, so I just remove it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Alan Cox <alan@linux.intel.com>
