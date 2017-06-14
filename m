Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:36620 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751979AbdFNNsz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 09:48:55 -0400
Date: Wed, 14 Jun 2017 14:48:40 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hyungwoo.yang@intel.com, divagar.mohandass@intel.com
Subject: Re: [PATCH v3 1/3] videodev2.h, v4l2-ioctl: add IPU3 raw10 color
 format
Message-ID: <20170614144840.4260501d@alans-desktop>
In-Reply-To: <1497385036-1002-2-git-send-email-yong.zhi@intel.com>
References: <1497385036-1002-1-git-send-email-yong.zhi@intel.com>
        <1497385036-1002-2-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 13 Jun 2017 15:17:14 -0500
Yong Zhi <yong.zhi@intel.com> wrote:

> Add IPU3 specific formats:
> 
> 	V4L2_PIX_FMT_IPU3_SBGGR10
> 	V4L2_PIX_FMT_IPU3_SGBRG10
> 	V4L2_PIX_FMT_IPU3_SGRBG10
> 	V4L2_PIX_FMT_IPU3_SRGGB10

As I said before these are just more bitpacked bayer formats with no
reason to encode them as IPUv3 specific names.

Alan
