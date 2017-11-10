Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:51288 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753114AbdKJSO4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 13:14:56 -0500
Date: Fri, 10 Nov 2017 20:14:52 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com, hyungwoo.yang@intel.com,
        chiranjeevi.rapolu@intel.com, jerry.w.hu@intel.com
Subject: Re: [PATCH v8 3/4] intel-ipu3: cio2: add new MIPI-CSI2 driver
Message-ID: <20171110181452.a62sw7nyhffa7abz@kekkonen.localdomain>
References: <1510266326-15516-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510266326-15516-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

On Thu, Nov 09, 2017 at 02:25:26PM -0800, Yong Zhi wrote:
> Hi, Sakari,
> 
> Fixed warnings about memset of pointer array and unsigned int used for 0 comparison
> reported by static code analysis tool, please squash this to the driver, thanks!!

Done, thanks!

I've pushed the result to the ipu3 branch in my tree.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
