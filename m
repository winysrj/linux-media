Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34306 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdHQSO4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 14:14:56 -0400
Date: Thu, 17 Aug 2017 11:14:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Johan Hovold <johan@kernel.org>, greybus-dev@lists.linaro.org,
        jacek.anaszewski@gmail.com, viresh.kumar@linaro.org,
        linux-leds@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 1/3] staging: greybus: light: fix memory leak in v4l2
 register
Message-ID: <20170817181457.GA8740@kroah.com>
References: <20170810154947.2283-1-sakari.ailus@linux.intel.com>
 <20170810154947.2283-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810154947.2283-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 10, 2017 at 06:49:45PM +0300, Sakari Ailus wrote:
> From: Rui Miguel Silva <rmfrfs@gmail.com>
> 
> We are allocating memory for the v4l2 flash configuration structure and
> leak it in the normal path. Just use the stack for this as we do not
> use it outside of this function.
> 
> Also use IS_ERR() instead of IS_ERR_OR_NULL() to check return value from
> v4l2_flash_init() for it never returns NULL.
> 
> Fixes: 2870b52bae4c ("greybus: lights: add lights implementation")
> Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/staging/greybus/light.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)

Does not apply to my tree :(
