Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33412 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751387AbdKEXQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 18:16:58 -0500
Date: Mon, 6 Nov 2017 01:16:56 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v1] [media] v4l2-ctrls: Don't validate BITMASK twice
Message-ID: <20171105231656.5k4nyldsu5p77rio@valkosipuli.retiisi.org.uk>
References: <20171103133539.35305-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103133539.35305-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 03, 2017 at 03:35:39PM +0200, Andy Shevchenko wrote:
> There is no need to repeat what check_range() does for us, i.e. BITMASK
> validation in v4l2_ctrl_new().
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
