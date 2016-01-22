Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbcAVNgu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 08:36:50 -0500
Subject: Re: [v4l-utils PATCH v2 2/3] libv4l2subdev: Add a function to list
 library supported pixel codes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
References: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com>
 <1449587716-22954-3-git-send-email-sakari.ailus@linux.intel.com>
 <1686411.P10t21bMUM@avalon>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56A2306F.4070808@linux.intel.com>
Date: Fri, 22 Jan 2016 15:36:47 +0200
MIME-Version: 1.0
In-Reply-To: <1686411.P10t21bMUM@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Tuesday 08 December 2015 17:15:15 Sakari Ailus wrote:
>> Also mark which format definitions are compat definitions for the
>> pre-existing codes. This way we don't end up listing the same formats
>> twice.
> 
> Wouldn't it be easier to add a function to return the whole array (and 
> terminate it with an empty entry to avoid having to return both the array and 
> the length=) ?

Now that I'm actually thinking about making that change, I have a few
concerns:

- This is not in line with the other APIs in the library, they mirror
the IOCTL behaviour (it's another debate whether this is a good idea or
not).

- I need a new statically allocated array for that. I think I'll change
my sed script. Allocating an array when the function is called the first
time isn't a great idea either, there's a problem with re-entrancy and
it's a memory leak, too.

So don't complain about these when I send an updated version. ;-)

-- 
Cheers,

Sakari Ailus
sakari.ailus@linux.intel.com
