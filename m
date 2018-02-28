Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23888 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752427AbeB1Nb3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 08:31:29 -0500
Date: Wed, 28 Feb 2018 15:31:26 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Rob Herring <robh@kernel.org>
Cc: Andy Yeh <andy.yeh@intel.com>, linux-media@vger.kernel.org,
        Tomasz Figa <tfiga@google.com>, devicetree@vger.kernel.org,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [v5 2/2] media: dt-bindings: Add bindings for Dongwoon DW9807
 voice coil
Message-ID: <20180228133126.cusxnid64xd5uawu@paasikivi.fi.intel.com>
References: <1519402422-9595-1-git-send-email-andy.yeh@intel.com>
 <1519402422-9595-3-git-send-email-andy.yeh@intel.com>
 <CAL_JsqKd8dxF1eSkST1GyKCS_bkzALv2aGHC9TXHWfnrxx33SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKd8dxF1eSkST1GyKCS_bkzALv2aGHC9TXHWfnrxx33SQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thanks for the review.

On Tue, Feb 27, 2018 at 04:10:31PM -0600, Rob Herring wrote:
> On Fri, Feb 23, 2018 at 10:13 AM, Andy Yeh <andy.yeh@intel.com> wrote:
> > From: Alan Chiang <alanx.chiang@intel.com>
> >
> > Dongwoon DW9807 is a voice coil lens driver.
> >
> > Also add a vendor prefix for Dongwoon for one did not exist previously.
> 
> Where's that?

Added by aece98a912d92444ea9da03b04269407d1308f1f . So that line isn't
relevant indeed and should be removed.

> 
> >
> > Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> > ---
> >  Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt | 9 +++++++++
> 
> DACs generally go in bindings/iio/dac/

We have quite a few lens voice coil drivers under bindings/media/i2c now. I
don't really object to putting this one to bindings/iio/dac but then the
rest should be moved as well.

The camera LED flash drivers are under bindings/leds so this would actually
be analoguous to that. The lens voice coil drivers are perhaps still a bit
more bound to the domain (camera) than the LED flash drivers.

I can send a patch if you think the existing bindings should be moved; let
me know.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
