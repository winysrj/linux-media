Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:42537 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751825AbdITKw6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 06:52:58 -0400
Date: Wed, 20 Sep 2017 13:51:53 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: Re: [PATCH v13 13/25] v4l: async: Allow async notifier register call
 succeed with no subdevs
Message-ID: <20170920105153.ohsdp4cgawdsjsae@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <20170919145831.uztphjdtd3fdxzvr@valkosipuli.retiisi.org.uk>
 <20170919150348.2jsqtxbk6bji4gdb@valkosipuli.retiisi.org.uk>
 <2195038.iUeBRvYfe2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2195038.iUeBRvYfe2@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Sep 19, 2017 at 08:54:12PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday, 19 September 2017 18:03:48 EEST Sakari Ailus wrote:
> > On Tue, Sep 19, 2017 at 05:58:32PM +0300, Sakari Ailus wrote:
> > >> This skips adding the notifier to the notifier_list. Won't this result
> > >> in an oops when calling list_del(&notifier->list) in
> > >> v4l2_async_notifier_unregister() ?
> > > 
> > > Good point. I'll add initialising the list head to the register function,
> > > with an appropriate comment.
> > 
> > I'll set v4l2_dev NULL instead; no tricks with lists needed.
> 
> Shouldn't the notifier still be added to the notifier_list ?

Would there be any benefit of that?

The notifier's v4l2_dev field is also used to determine whether the
notifier is registered currently. If the notifier is added to the notifier
list, we need to remove it in unregistration as well.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
