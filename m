Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:43218 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751787AbdFGRzX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 13:55:23 -0400
Date: Wed, 7 Jun 2017 18:55:15 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com,
        hverkuil@xs4all.nl, hyungwoo.yang@intel.com
Subject: Re: [PATCH v2 2/3] [media] doc-rst: add IPU3 raw10 bayer pixel
 format definitions
Message-ID: <20170607185515.35f7ef16@lxorguk.ukuu.org.uk>
In-Reply-To: <1496799279-8774-3-git-send-email-yong.zhi@intel.com>
References: <1496799279-8774-1-git-send-email-yong.zhi@intel.com>
        <1496799279-8774-3-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> +
> +10-bit Bayer formats
> +
> +Description
> +===========
> +
> +These four pixel formats are used by Intel IPU3 driver,

Are the same formats present in IPUv2, will they ever be present in other
hardware.

If so (and I think it is so...) then it's not a good idea to encode ipu3
in the name. Something like V4l2_PIX_FMT_SBGGR10_PACKED might be better ?

Alan
