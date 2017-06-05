Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:54480 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751180AbdFEUrK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Jun 2017 16:47:10 -0400
Date: Mon, 5 Jun 2017 21:46:59 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org,
        rajmohan.mani@intel.com, tuukka.toivonen@intel.com
Subject: Re: [PATCH 00/12] Intel IPU3 ImgU patchset
Message-ID: <20170605214659.6678540b@lxorguk.ukuu.org.uk>
In-Reply-To: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> data structures used by the firmware and the hardware. On top of that,
> the algorithms require highly specialized user space to make meaningful
> use of them. For these reasons it has been chosen video buffers to pass
> the parameters to the device.

You should provide a pointer to the relevant userspace here as well.
People need that to evaluate the interface.

> 6 and 7 provide some utility functions and manage IPU3 fw download and
> install.

and a pointer to the firmware (which ideally should go into the standard
Linux firmware git)

Otherwise this is so much nicer than the IPUv2 code!

Alan
