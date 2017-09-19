Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57124 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750918AbdISHOq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 03:14:46 -0400
Date: Tue, 19 Sep 2017 10:14:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v2] media: ov13858: Fix 4224x3136 video flickering at
 some vblanks
Message-ID: <20170919071443.wfd7leio44euozze@valkosipuli.retiisi.org.uk>
References: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <d946c138dc7d9657e986bfe37d255a595ad1671c.1505774663.git.chiranjeevi.rapolu@intel.com>
 <CAAFQd5Cqxrbutd-FL3EAJde1q2JmjY+6xHAMGuGjkR3VdpQxQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5Cqxrbutd-FL3EAJde1q2JmjY+6xHAMGuGjkR3VdpQxQA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 19, 2017 at 01:32:27PM +0900, Tomasz Figa wrote:
> Hi Chiranjeevi,
> 
> On Tue, Sep 19, 2017 at 7:47 AM, Chiranjeevi Rapolu
> <chiranjeevi.rapolu@intel.com> wrote:
> > Previously, with crop (0, 0), (4255, 3167), VTS < 0xC9E was resulting in blank
> > frames sometimes. This appeared as video flickering. But we need VTS < 0xC9E to
> > get ~30fps.
> >
> > Omni Vision recommends to use crop (0,8), (4255, 3159) for 4224x3136. With this
> > crop, VTS 0xC8E is supported and yields ~30fps.
> >
> > Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> > ---
> > Changes in v2:
> >         - Include Tomasz clarifications in the commit message.
> 
> Thanks for explanation. It makes perfect sense now.
> 
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Thanks, applied!

Chiranjeevi: please wrap the commit message at 75 on the next time.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
