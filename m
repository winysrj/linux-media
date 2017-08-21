Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56506 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751063AbdHUHqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 03:46:13 -0400
Subject: Re: [v4l-utils PATCH 1/1] v4l2-compliance: Add support for metadata
 output
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: tfiga@chromium.org, yong.zhi@intel.com, hverkuil@xs4all.nl
References: <20170821073849.20487-1-sakari.ailus@linux.intel.com>
From: Sakari Ailus <sakari.ailus@retiisi.org.uk>
Message-ID: <de99628d-a409-1e0c-6ecf-2c69d3ac68ee@retiisi.org.uk>
Date: Mon, 21 Aug 2017 10:46:09 +0300
MIME-Version: 1.0
In-Reply-To: <20170821073849.20487-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
> Add support for metadata output video nodes, in other words,
> V4L2_CAP_META_OUTPUT and V4L2_BUF_TYPE_META_OUTPUT.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi all,
> 
> This patch adds support for metadata output in v4l2-compliance.
> 
> It depends on the metadata output patch:
> 
> <URL:https://patchwork.linuxtv.org/patch/43308/>

Please ignore this version for now. This needs to be prepended with a
proper header update in a separate patch.

-- 
Sakari Ailus
sakari.ailus@retiisi.org.uk
