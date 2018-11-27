Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:10185 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbeK0UbU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 15:31:20 -0500
Date: Tue, 27 Nov 2018 11:33:59 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: bingbu.cao@intel.com
Cc: linux-media@vger.kernel.org, tfiga@chromium.org,
        andy.yeh@intel.com, bingbu.cao@linux.intel.com,
        luca@lucaceresoli.net
Subject: Re: [PATCH v2] media: unify some sony camera sensors pattern naming
Message-ID: <20181127093358.6gndnjyeuuccrixh@paasikivi.fi.intel.com>
References: <1543309406-611-1-git-send-email-bingbu.cao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543309406-611-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 27, 2018 at 05:03:26PM +0800, bingbu.cao@intel.com wrote:
> From: Bingbu Cao <bingbu.cao@intel.com>
> 
> Some Sony camera sensors have same pattern
> definitions, this patch unify the pattern naming
> to make it more clear to the userspace.
> 
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
> Reviewed-by: luca@lucaceresoli.net

Hi Bing Bu,

Sorry, I prefer your v1. :-)

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
