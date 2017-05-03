Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:44792 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdECVA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 17:00:58 -0400
Subject: Re: [PATCH 3/3] [media] intel-ipu3: cio2: Add new MIPI-CSI2 driver
To: Hans Verkuil <hverkuil@xs4all.nl>, Yong Zhi <yong.zhi@intel.com>,
        linux-media@vger.kernel.org
Cc: jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com
References: <cover.1493479141.git.yong.zhi@intel.com>
 <9cf19d01f6f85ac0e5969a2b2fcd5ad5ef8c1e22.1493479141.git.yong.zhi@intel.com>
 <4a486cd9-48f8-fcab-6abb-4e89671c95fe@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <775060aa-9f9c-005c-91a4-44a83e5ad35b@linux.intel.com>
Date: Thu, 4 May 2017 00:00:52 +0300
MIME-Version: 1.0
In-Reply-To: <4a486cd9-48f8-fcab-6abb-4e89671c95fe@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> Is it likely that there will be more Intel PCI drivers? If so, then we
> can consider putting it in pci/intel/ipu3/.

Maybe. There is more hardware and they're called IPUs, too. I think this 
naming would be a good idea going forward.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
