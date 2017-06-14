Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52654 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751600AbdFNW0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 18:26:45 -0400
Date: Thu, 15 Jun 2017 01:26:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, rajmohan.mani@intel.com,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH 00/12] Intel IPU3 ImgU patchset
Message-ID: <20170614222608.GU12407@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <20170605214659.6678540b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170605214659.6678540b@lxorguk.ukuu.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Mon, Jun 05, 2017 at 09:46:59PM +0100, Alan Cox wrote:
> > data structures used by the firmware and the hardware. On top of that,
> > the algorithms require highly specialized user space to make meaningful
> > use of them. For these reasons it has been chosen video buffers to pass
> > the parameters to the device.
> 
> You should provide a pointer to the relevant userspace here as well.
> People need that to evaluate the interface.

I know... there will be some user space software to use this interface but
it's unfortunately not available yet.

> 
> > 6 and 7 provide some utility functions and manage IPU3 fw download and
> > install.
> 
> and a pointer to the firmware (which ideally should go into the standard
> Linux firmware git)

Good question. Let me see what I can find.

> 
> Otherwise this is so much nicer than the IPUv2 code!

Thanks!

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
