Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:49168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934860AbcLOLpa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 06:45:30 -0500
Subject: Re: [RFC v3 21/21] omap3isp: Don't rely on devm for memory resource
 management
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
 <1551037.Hfmqsgr3In@avalon>
 <20161215113956.GF16630@valkosipuli.retiisi.org.uk>
 <3081773.GUJA4mrXhH@avalon>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <58528255.2070708@linux.intel.com>
Date: Thu, 15 Dec 2016 13:45:25 +0200
MIME-Version: 1.0
In-Reply-To: <3081773.GUJA4mrXhH@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/15/16 13:42, Laurent Pinchart wrote:
> You can split that part out. The devm_* removal is independent and could be 
> moved to the beginning of the series.

Where do you release the memory in that case? In driver's remove(), i.e.
this patch would simply move that code to isp_remove()?

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
