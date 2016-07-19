Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27442 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbcGSHwl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 03:52:41 -0400
Subject: Re: [RFC 00/16] Make use of kref in media device, grab references as
 needed
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
 <20160715071913.009908a1@recife.lan> <578DD673.2010601@linux.intel.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <578DDC46.2060900@linux.intel.com>
Date: Tue, 19 Jul 2016 10:52:38 +0300
MIME-Version: 1.0
In-Reply-To: <578DD673.2010601@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
> I believe people are more familiar with the state of the code with the
> reverts than without them. The first two reverted patches I don't really
> have a problem with, but they depend on the third reverted patch which
> is more problematic and they'll no longer be needed afterwards. To
> refresh our memory:

"media: fix media devnode ioctl/syscall and unregister race" is actually
a part of the workaround as well:

<URL:http://www.spinics.net/lists/linux-media/msg101295.html>
<URL:http://www.spinics.net/lists/linux-media/msg101327.html>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
