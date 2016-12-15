Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48034 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752837AbcLOME2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:04:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl, mchehab@osg.samsung.com,
        shuahkh@osg.samsung.com
Subject: Re: [RFC v3 21/21] omap3isp: Don't rely on devm for memory resource management
Date: Thu, 15 Dec 2016 13:57:45 +0200
Message-ID: <34468031.gaR5u7AJSf@avalon>
In-Reply-To: <58528255.2070708@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com> <3081773.GUJA4mrXhH@avalon> <58528255.2070708@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 15 Dec 2016 13:45:25 Sakari Ailus wrote:
> Hi Laurent,
> 
> On 12/15/16 13:42, Laurent Pinchart wrote:
> > You can split that part out. The devm_* removal is independent and could
> > be moved to the beginning of the series.
> 
> Where do you release the memory in that case? In driver's remove(), i.e.
> this patch would simply move that code to isp_remove()?

Yes, the kfree() calls would be in isp_remove(). The patch will then be 
faithful to its $SUBJECT, and moving to a release() handler should be done in 
a separate patch.

-- 
Regards,

Laurent Pinchart

