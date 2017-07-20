Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39682 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935122AbdGTQJ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 12:09:59 -0400
Date: Thu, 20 Jul 2017 19:09:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: Re: [RFC 11/19] v4l2-async: Register sub-devices before calling
 bound callback
Message-ID: <20170720160954.47rbdwpxx6d4ezvq@valkosipuli.retiisi.org.uk>
References: <20170718190401.14797-1-sakari.ailus@linux.intel.com>
 <20170718190401.14797-12-sakari.ailus@linux.intel.com>
 <03f4a632-30b8-bdc8-2b03-fa7c3eb811a1@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03f4a632-30b8-bdc8-2b03-fa7c3eb811a1@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Jul 19, 2017 at 01:24:54PM +0200, Hans Verkuil wrote:
> On 18/07/17 21:03, Sakari Ailus wrote:
> > The async notifier supports three callbacks to the notifier: bound, unbound
> > and complete. The complete callback has been traditionally used for
> > creating the sub-device nodes.
> > 
> > This approach has an inherent weakness: if registration of a single
> > sub-device fails for whatever reason, it renders the entire media device
> > unusable even if only that piece of hardware is not working. This is a
> > problem in particular in systems with multiple independent image pipelines
> > on a single device. We have had such devices (e.g. omap3isp) supported for
> > a number of years and the problem is growing more pressing as time passes
> > so there is an incentive to resolve this.
> 
> I don't think this is a good reason. If one of the subdevices fail, then your
> hardware is messed up and there is no point in continuing.

That's entirely untrue in general case.

If you have e.g. a mobile phone with a single camera, yes, you're right.
But most mobile phones have two cameras these days. Embedded systems may
have many, think of automotive use cases: you could have five or ten
cameras there.

It is not feasible to prevent the entire system from working if a single
component is at fault --- this is really any component such as a lens
controller.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
