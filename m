Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55248 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751391AbeAYNQd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 08:16:33 -0500
Date: Thu, 25 Jan 2018 15:16:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] v4l2-dev.h: fix symbol collision in
 media_entity_to_video_device()
Message-ID: <20180125131630.jzxunfs427s7vc2r@valkosipuli.retiisi.org.uk>
References: <20180125130852.4779-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180125130852.4779-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 25, 2018 at 02:08:52PM +0100, Niklas Söderlund wrote:
> A recent change to the media_entity_to_video_device() macro breaks some
> use-cases for the macro due to a symbol collision. Before the change
> this worked:
> 
>     vdev = media_entity_to_video_device(link->sink->entity);
> 
> While after the change it results in a compiler error "error: 'struct
> video_device' has no member named 'link'; did you mean 'lock'?". While
> the following still works after the change.
> 
>     struct media_entity *entity = link->sink->entity;
>     vdev = media_entity_to_video_device(entity);
> 
> Fix the collision by renaming the macro argument to '__entity'.
> 
> Fixes: 69b925c5fc36d8f1 ("media: v4l2-dev.h: add kernel-doc to two macros")
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
