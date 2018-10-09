Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:8643 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbeJITF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 15:05:28 -0400
Date: Tue, 9 Oct 2018 14:48:47 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: docs: Document metadata format in struct
 v4l2_format
Message-ID: <20181009114847.rsl6nhk2sjtplr4b@paasikivi.fi.intel.com>
References: <20181009113106.14202-1-sakari.ailus@linux.intel.com>
 <14bd1646-6b9d-1b14-5f21-ba39cd8a5391@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14bd1646-6b9d-1b14-5f21-ba39cd8a5391@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 09, 2018 at 01:32:57PM +0200, Hans Verkuil wrote:
> On 10/09/18 13:31, Sakari Ailus wrote:
> > The format fields in struct v4l2_format were otherwise reported but the
> > meta field was missing. Document it.
> > 
> > Reported-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Thanks!

Thanks!

I'll replace "reported" in the commit message by "documented" for the pull
request.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
