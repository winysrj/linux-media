Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36700 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752417AbdFNK5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 06:57:55 -0400
Date: Wed, 14 Jun 2017 13:57:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rajmohan Mani <rajmohan.mani@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        hverkuil@xs4all.nl, tfiga@chromium.org, s.nawrocki@samsung.com,
        tuukka.toivonen@intel.com
Subject: Re: [PATCH v8] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170614105747.GN12407@valkosipuli.retiisi.org.uk>
References: <1496477500-4675-1-git-send-email-rajmohan.mani@intel.com>
 <20170603084031.GS1019@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603084031.GS1019@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 03, 2017 at 11:40:32AM +0300, Sakari Ailus wrote:
> Hi Rajmohan,
> 
> On Sat, Jun 03, 2017 at 01:11:40AM -0700, Rajmohan Mani wrote:
> > DW9714 is a 10 bit DAC, designed for linear
> > control of voice coil motor.
> > 
> > This driver creates a V4L2 subdevice and
> > provides control to set the desired focus.
> > 
> > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Applied to my tree.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
