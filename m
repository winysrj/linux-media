Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:54464 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751186AbdFEUnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:46 -0400
Date: Mon, 5 Jun 2017 21:43:27 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com
Subject: Re: [PATCH 01/12] videodev2.h, v4l2-ioctl: add IPU3 meta buffer
 format
Message-ID: <20170605214327.19b26021@lxorguk.ukuu.org.uk>
In-Reply-To: <1496695157-19926-2-git-send-email-yong.zhi@intel.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
        <1496695157-19926-2-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon,  5 Jun 2017 15:39:06 -0500
Yong Zhi <yong.zhi@intel.com> wrote:

> Add the IPU3 specific processing parameter format
> V4L2_META_FMT_IPU3_PARAMS and metadata formats
> for 3A and other statistics:
> 
>   V4L2_META_FMT_IPU3_PARAMS
>   V4L2_META_FMT_IPU3_STAT_3A
>   V4L2_META_FMT_IPU3_STAT_DVS
>   V4L2_META_FMT_IPU3_STAT_LACE

Are these specific to IPU v3 or do they match other IPU versions ?

Alan
