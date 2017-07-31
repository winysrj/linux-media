Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:57888 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750807AbdGaIEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 04:04:24 -0400
Subject: Re: [PATCH 0/4] v4l: async: fixes for
 v4l2_async_notifier_unregister()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <250b9ba2-10b0-5436-d533-ae05e062fd18@xs4all.nl>
Date: Mon, 31 Jul 2017 10:04:14 +0200
MIME-Version: 1.0
In-Reply-To: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2017 12:31 AM, Niklas Söderlund wrote:
> Hi,
> 
> This series is based on top of media-tree and some patches where
> previously part of the series '[PATCH v5 0/4] v4l2-async: add
> subnotifier registration for subdevices'. Hans suggested the cleanups
> could be broken out to a separate series, so this is this series :-)
> 
> The aim of this series is to cleanup and document some of the odd things
> that happens in v4l2_async_notifier_unregister(). The purpose for this
> in the short term is to make it easier to implement subnotifiers which
> both I and Sakari are trying to address, this feature is blocking other
> drivers such as the Renesas R-Car CSI-2 receiver driver. And in the long
> run (I hope) to make it easier to get rid of the need to do re-probing
> at all in v4l2_async_notifier_unregister() :-)
> 
> Niklas Söderlund (4):
>   v4l: async: fix unbind error in v4l2_async_notifier_unregister()
>   v4l: async: abort if memory allocation fails when unregistering
>     notifiers
>   v4l: async: do not hold list_lock when re-probing devices
>   v4l: async: add comment about re-probing to
>     v4l2_async_notifier_unregister()
> 
>  drivers/media/v4l2-core/v4l2-async.c | 49 ++++++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 

Looks good to me, but I'd like Sakari's Ack as well. He's still on vacation
for another week, so it won't be merged before next week at the earliest.

Regards,

	Hans
