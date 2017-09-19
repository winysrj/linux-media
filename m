Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39472 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbdISRyN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 13:54:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 13/25] v4l: async: Allow async notifier register call succeed with no subdevs
Date: Tue, 19 Sep 2017 20:54:12 +0300
Message-ID: <2195038.iUeBRvYfe2@avalon>
In-Reply-To: <20170919150348.2jsqtxbk6bji4gdb@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <20170919145831.uztphjdtd3fdxzvr@valkosipuli.retiisi.org.uk> <20170919150348.2jsqtxbk6bji4gdb@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 18:03:48 EEST Sakari Ailus wrote:
> On Tue, Sep 19, 2017 at 05:58:32PM +0300, Sakari Ailus wrote:
> >> This skips adding the notifier to the notifier_list. Won't this result
> >> in an oops when calling list_del(&notifier->list) in
> >> v4l2_async_notifier_unregister() ?
> > 
> > Good point. I'll add initialising the list head to the register function,
> > with an appropriate comment.
> 
> I'll set v4l2_dev NULL instead; no tricks with lists needed.

Shouldn't the notifier still be added to the notifier_list ?

-- 
Regards,

Laurent Pinchart
