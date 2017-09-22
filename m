Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40578 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751637AbdIVGdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 02:33:17 -0400
Date: Fri, 22 Sep 2017 09:33:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        =?iso-8859-1?B?Suly6W15?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Colin Ian King <colin.king@canonical.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] [media] staging: atomisp: use clock framework for
 camera clocks
Message-ID: <20170922063313.xozktn3tyjp3wno6@valkosipuli.retiisi.org.uk>
References: <20170920205431.17248-1-pierre-louis.bossart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920205431.17248-1-pierre-louis.bossart@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pierre-Louis,

On Wed, Sep 20, 2017 at 03:53:58PM -0500, Pierre-Louis Bossart wrote:
> The Atom ISP driver initializes and configures PMC clocks which are
> already handled by the clock framework.
> 
> Remove all legacy vlv2_platform_clock stuff and move to the clk API to
> avoid conflicts, e.g. with audio machine drivers enabling the MCLK for
> external codecs
> 
> Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
> Tested-by: Carlo Caione <carlo@endlessm.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

I've applied the patch with small changes, there were other patches
changing the deleted files.

The tree is here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=atomisp>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
