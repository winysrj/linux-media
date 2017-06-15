Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34286 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750774AbdFOIiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:38:13 -0400
Date: Thu, 15 Jun 2017 11:37:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, Rajmohan Mani <rajmohan.mani@intel.com>,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH 00/12] Intel IPU3 ImgU patchset
Message-ID: <20170615083739.GA12407@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <20170605214659.6678540b@lxorguk.ukuu.org.uk>
 <20170614222608.GU12407@valkosipuli.retiisi.org.uk>
 <CAHp75Vf7o8wO3Vpjni2dxyiHOX7Uy88R49RGzRB2SVVViWQR6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf7o8wO3Vpjni2dxyiHOX7Uy88R49RGzRB2SVVViWQR6A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 15, 2017 at 11:26:05AM +0300, Andy Shevchenko wrote:
> On Thu, Jun 15, 2017 at 1:26 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > On Mon, Jun 05, 2017 at 09:46:59PM +0100, Alan Cox wrote:
> 
> >> and a pointer to the firmware (which ideally should go into the standard
> >> Linux firmware git)
> >
> > Good question. Let me see what I can find.
> 
> Just a side note: it would be good to put it there. Hopefully the
> firmware for IPUv3 is not going to be changed two times per day.

This one is rather stable in terms of changes. If there are going to be
changes they are very likely to be rare.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
