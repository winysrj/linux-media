Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54834 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751393AbdHJHM2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 03:12:28 -0400
Date: Thu, 10 Aug 2017 10:12:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>
Subject: Re: [PATCH v2] media: ov5670: Fix incorrect frame timing reported to
 user
Message-ID: <20170810071225.fqkwjto4ayn3tca5@valkosipuli.retiisi.org.uk>
References: <1502306262-30400-1-git-send-email-chiranjeevi.rapolu@intel.com>
 <47f8b8293a5ea31c2cec771398fbcdaf0f8fe808.1502315473.git.chiranjeevi.rapolu@intel.com>
 <CAAFQd5BwCxB7pDokX0qAuGaRoMLt8YV_e0-QPxafhee7iN4gTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5BwCxB7pDokX0qAuGaRoMLt8YV_e0-QPxafhee7iN4gTQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 10, 2017 at 04:00:05PM +0900, Tomasz Figa wrote:
> Hi Chiranjeevi,
> 
> On Thu, Aug 10, 2017 at 6:59 AM, Chiranjeevi Rapolu
> <chiranjeevi.rapolu@intel.com> wrote:
> > Previously, pixel-rate/(pixels-per-line * lines-per-frame) was
> > yielding incorrect frame timing for the user.
> >
> > OV sensor is using internal timing and this requires
> > conversion (internal timing -> PPL) for correct HBLANK calculation.
> >
> > Now, change pixels-per-line domain from internal sensor clock to
> > pixels domain. Set HBLANK read-only because fixed PPL is used for all
> > resolutions. And, use more accurate link-frequency 422.4MHz instead of
> > rounding down to 420MHz.
> >
> > Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
> > ---
> > Changes in v2:
> >         - Change subject to reflect frame timing info.
> >         - Change OV5670_DEF_PPL so that it doesn't convey a register default
> >           value. And, add more comments to it.
> >  drivers/media/i2c/ov5670.c | 45 +++++++++++++++++++++++----------------------
> >  1 file changed, 23 insertions(+), 22 deletions(-)
> 
> Okay, the numbers in this version finally make sense. Thanks for
> figuring this out.
> 
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Thanks, applied!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
