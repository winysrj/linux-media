Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:15350 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbcAVMXu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 07:23:50 -0500
Subject: Re: [v4l-utils PATCH v2 2/3] libv4l2subdev: Add a function to list
 library supported pixel codes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
References: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com>
 <1449587716-22954-3-git-send-email-sakari.ailus@linux.intel.com>
 <1686411.P10t21bMUM@avalon>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56A21F36.1050106@linux.intel.com>
Date: Fri, 22 Jan 2016 14:23:18 +0200
MIME-Version: 1.0
In-Reply-To: <1686411.P10t21bMUM@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

Fine for me. I'll resend.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
