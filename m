Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:56549 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967148AbeCAJ7O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 04:59:14 -0500
Date: Thu, 1 Mar 2018 10:59:09 +0100
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jacopo Mondi <jacopo@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: renesas-ceu: mark PM functions as __maybe_unused
Message-ID: <20180301095909.of6irggy4bke6dmx@verge.net.au>
References: <20180228231951.460060-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180228231951.460060-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 01, 2018 at 12:19:37AM +0100, Arnd Bergmann wrote:
> The PM runtime operations are unused when CONFIG_PM is disabled,
> leading to a harmless warning:
> 
> drivers/media/platform/renesas-ceu.c:1003:12: error: 'ceu_runtime_suspend' defined but not used [-Werror=unused-function]
>  static int ceu_runtime_suspend(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/renesas-ceu.c:987:12: error: 'ceu_runtime_resume' defined but not used [-Werror=unused-function]
>  static int ceu_runtime_resume(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~
> 
> This adds a __maybe_unused annotation to shut up the warning.
> 
> Fixes: 32e5a70dc8f4 ("media: platform: Add Renesas CEU driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
