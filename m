Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44561 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbdB1Ow4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 09:52:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] omap3isp: Disable streaming at driver unbind time
Date: Tue, 28 Feb 2017 16:53:11 +0200
Message-ID: <10713629.uzrjKBVcAn@avalon>
In-Reply-To: <a9989567-8792-480d-88e0-73ddecf0a742@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com> <1825906.3DC6oLSMPM@avalon> <a9989567-8792-480d-88e0-73ddecf0a742@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 28 Feb 2017 16:00:01 Sakari Ailus wrote:
> > On Monday 20 Feb 2017 17:22:20 Sakari Ailus wrote:
> >> Once the driver is unbound accessing the hardware is not allowed anymore.
> >> Due to this, disable streaming when the device driver is unbound. The
> >> states of the associated objects related to Media controller and
> >> videobuf2 frameworks are updated as well, just like if the application
> >> disabled streaming explicitly.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > This looks mostly good to me, although I'm a bit concerned about race
> > conditions related to buffer handling. I don't think this patch introduces
> > any new one though, so
> > 
> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > We'll have to go through buffer management at some point in the near
> > future, including from a V4L2 API point of view I think.
> 
> Thanks for the review!
> 
> Are you happy with me sending a pull request on the set, or would you
> prefer to pick the omap3isp patches? In the latter case I'll send a fix
> for the issue in the first patch.

Feel free to send a pull request, I don't have anything conflicting queued for 
v4.12.

-- 
Regards,

Laurent Pinchart
