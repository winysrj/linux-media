Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40152 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752132AbdFQSn4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Jun 2017 14:43:56 -0400
Date: Sat, 17 Jun 2017 21:43:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        tfiga@chromium.org, Rajmohan Mani <rajmohan.mani@intel.com>,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH v2 09/12] intel-ipu3: css hardware setup
Message-ID: <20170617184348.GW12407@valkosipuli.retiisi.org.uk>
References: <1497478767-10270-1-git-send-email-yong.zhi@intel.com>
 <1497478767-10270-10-git-send-email-yong.zhi@intel.com>
 <CAHp75VfK7qL5j+hDZj-QKcqf85_JiBDG7N8XET4a59Kfet5z1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VfK7qL5j+hDZj-QKcqf85_JiBDG7N8XET4a59Kfet5z1g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 17, 2017 at 01:54:51AM +0300, Andy Shevchenko wrote:
> On Thu, Jun 15, 2017 at 1:19 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> 
> Commit message.
> 
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> 
> > +static void writes(void *mem, ssize_t len, void __iomem *reg)
> > +{
> > +       while (len >= 4) {
> > +               writel(*(u32 *)mem, reg);
> > +               mem += 4;
> > +               reg += 4;
> > +               len -= 4;
> > +       }
> > +}
> 
> Again, I just looked into patches and first what I see is reinventing the wheel.
> 
> memcpy_toio()

Hi Andy,

That doesn't quite work: the hardware only supports 32-bit access.

So the answer is writesl().

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
