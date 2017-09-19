Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34860 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751165AbdISPDv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 11:03:51 -0400
Date: Tue, 19 Sep 2017 18:03:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 13/25] v4l: async: Allow async notifier register call
 succeed with no subdevs
Message-ID: <20170919150348.2jsqtxbk6bji4gdb@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170915141724.23124-14-sakari.ailus@linux.intel.com>
 <1674305.pu9Ti8eC3U@avalon>
 <2068881.oMWDSm4mNc@avalon>
 <20170919145831.uztphjdtd3fdxzvr@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919145831.uztphjdtd3fdxzvr@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 19, 2017 at 05:58:32PM +0300, Sakari Ailus wrote:
> > This skips adding the notifier to the notifier_list. Won't this result in an 
> > oops when calling list_del(&notifier->list) in 
> > v4l2_async_notifier_unregister() ?
> 
> Good point. I'll add initialising the list head to the register function,
> with an appropriate comment.

I'll set v4l2_dev NULL instead; no tricks with lists needed.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
