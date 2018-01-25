Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:12657 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeAYRgp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 12:36:45 -0500
From: "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: RE: [PATCH v1] media: ov13858: Avoid possible null first frame
Date: Thu, 25 Jan 2018 17:36:44 +0000
Message-ID: <8408A4B5C50F354EA5F62D9FC805153D2C53637E@ORSMSX115.amr.corp.intel.com>
References: <1516854879-15029-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <20180125102958.dxky4qrzv5ags6av@paasikivi.fi.intel.com>
In-Reply-To: <20180125102958.dxky4qrzv5ags6av@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

>I'll apply this now, however I see that most of the registers in the four modes are the same. In the future it'd be good to separate the parts that are common in all of them (to be written in sensor power-on) to make this (slightly) more maintainable.

Thanks for the review. Makes sense. Not sure how it impacts because the sequence of writes will be different, need thorough testing to confirm nothing is broken.
