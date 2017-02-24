Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:12376 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751122AbdB1Stq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 13:49:46 -0500
Date: Fri, 24 Feb 2017 15:13:19 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] omap3isp: Disable streaming at driver unbind time
Message-ID: <20170224131318.GA7193@mara.localdomain>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
 <1825906.3DC6oLSMPM@avalon>
 <a9989567-8792-480d-88e0-73ddecf0a742@linux.intel.com>
 <10713629.uzrjKBVcAn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10713629.uzrjKBVcAn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 28, 2017 at 04:53:11PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday 28 Feb 2017 16:00:01 Sakari Ailus wrote:
> > > On Monday 20 Feb 2017 17:22:20 Sakari Ailus wrote:
> > >> Once the driver is unbound accessing the hardware is not allowed anymore.
> > >> Due to this, disable streaming when the device driver is unbound. The
> > >> states of the associated objects related to Media controller and
> > >> videobuf2 frameworks are updated as well, just like if the application
> > >> disabled streaming explicitly.
> > >> 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > 
> > > This looks mostly good to me, although I'm a bit concerned about race
> > > conditions related to buffer handling. I don't think this patch introduces
> > > any new one though, so
> > > 
> > > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > 
> > > We'll have to go through buffer management at some point in the near
> > > future, including from a V4L2 API point of view I think.
> > 
> > Thanks for the review!
> > 
> > Are you happy with me sending a pull request on the set, or would you
> > prefer to pick the omap3isp patches? In the latter case I'll send a fix
> > for the issue in the first patch.
> 
> Feel free to send a pull request, I don't have anything conflicting queued for 
> v4.12.

Ack. I'll send a pull request then.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
