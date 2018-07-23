Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55316 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388302AbeGWNg7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 09:36:59 -0400
Date: Mon, 23 Jul 2018 15:35:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 16/17] media: v4l2: async: Remove notifier subdevs
 array
Message-ID: <20180723123557.bfxxsqqhlaj3ccwc@valkosipuli.retiisi.org.uk>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-17-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1531175957-1973-17-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Thanks for the update.

On Mon, Jul 09, 2018 at 03:39:16PM -0700, Steve Longerbeam wrote:
> All platform drivers have been converted to use
> v4l2_async_notifier_add_subdev(), in place of adding
> asd's to the notifier subdevs array. So the subdevs
> array can now be removed from struct v4l2_async_notifier,
> and remove the backward compatibility support for that
> array in v4l2-async.c.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

This set removes the subdevs and num_subdevs fieldsfrom the notifier (as
discussed previously) but it doesn't include the corresponding
driver changes. Is there a patch missing from the set?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
