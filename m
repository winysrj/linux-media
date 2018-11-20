Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:61321 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbeKTNZm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 08:25:42 -0500
From: "Kao, Ben" <ben.kao@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "Yeh, Andy" <andy.yeh@intel.com>
Subject: RE: media: ov8856: Add support for OV8856 sensor
Date: Tue, 20 Nov 2018 02:58:48 +0000
Message-ID: <B2FFC9E4F0F8F940BDE6BC43B3589C277D759404@PGSMSX112.gar.corp.intel.com>
References: <1541648506-13744-1-git-send-email-ben.kao@intel.com>
 <20181116081926.7y5h2pu6tmk2adbx@paasikivi.fi.intel.com>
In-Reply-To: <20181116081926.7y5h2pu6tmk2adbx@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> Hi Ben,
> 
> On Thu, Nov 08, 2018 at 11:41:46AM +0800, Ben Kao wrote:
> > This patch adds driver for Omnivision's ov8856 sensor, the driver
> > supports following features:
> >
> > - manual exposure/gain(analog and digital) control support
> > - two link frequencies
> > - VBLANK/HBLANK support
> > - test pattern support
> > - media controller support
> > - runtime pm support
> > - supported resolutions
> >   + 3280x2464 at 30FPS
> >   + 1640x1232 at 30FPS
> >
> > Signed-off-by: Ben Kao <ben.kao@intel.com>
> 
> I just realised the driver is missing the MAINTAINERS entry. Could you provide
> one? Just the diff is fine, I'll then squash it to the patch.
> 
> Thanks.
> 
> --
> Regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com

We are still waiting for Omnivision's approval.
Once if get Omnivision's approval, I will update patch with MAINTAINERS entry.

Thanks.

Regards,

Ben Kao
