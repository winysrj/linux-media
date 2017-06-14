Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36714 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752200AbdFNK6I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 06:58:08 -0400
Date: Wed, 14 Jun 2017 13:57:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hyungwoo Yang <hyungwoo.yang@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        jian.xu.zheng@intel.com, tfiga@chromium.org, cedric.hsu@intel.com
Subject: Re: [PATCH RESEND v11 1/1] [media] i2c: add support for OV13858
 sensor
Message-ID: <20170614105734.GM12407@valkosipuli.retiisi.org.uk>
References: <1497391576-24619-1-git-send-email-hyungwoo.yang@intel.com>
 <20170614101249.GJ12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170614101249.GJ12407@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 14, 2017 at 01:12:49PM +0300, Sakari Ailus wrote:
> Hi Hyungwoo,
> 
> On Tue, Jun 13, 2017 at 03:06:16PM -0700, Hyungwoo Yang wrote:
> > This patch adds driver for Omnivision's ov13858
> > sensor, the driver supports following features:
> > 
> > - manual exposure/gain(analog and digital) control support
> > - two link frequencies
> > - VBLANK/HBLANK support
> > - test pattern support
> > - media controller support
> > - runtime pm support
> > - supported resolutions
> >   + 4224x3136 at 30FPS
> >   + 2112x1568 at 30FPS(default) and 60FPS
> >   + 2112x1188 at 30FPS(default) and 60FPS
> >   + 1056x784 at 30FPS(default) and 60FPS
> > 
> > Signed-off-by: Hyungwoo Yang <hyungwoo.yang@intel.com>
> > ---
> 
> If you make changes, please detail them in this part of a single patch. In
> this case, this would have included mentioning that the expected
> clock-frequency property value has changed. And the subject should have
> indicated v12. "RESEND" is only used if there are no changes to the patches
> as such.
> 
> I've applied this to my tree.

And switched to V4L2_CID_DIGITAL_GAIN, too.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
