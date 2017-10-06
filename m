Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39015 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751890AbdJFM5U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 08:57:20 -0400
Date: Fri, 6 Oct 2017 15:57:16 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Devid Antonio Filoni <d.filoni@ubuntu.com>
Cc: andriy.shevchenko@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?iso-8859-1?B?Suly6W15?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v4] staging: atomisp: add a driver for ov5648 camera
 sensor
Message-ID: <20171006125716.txmwvuhhxdw2fyji@paasikivi.fi.intel.com>
References: <1507073092-11936-1-git-send-email-d.filoni@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507073092-11936-1-git-send-email-d.filoni@ubuntu.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devid,

On Wed, Oct 04, 2017 at 01:23:36AM +0200, Devid Antonio Filoni wrote:
> I was not able to properly test this patch on my Lenovo Miix 310 due to other
> issues with atomisp, the output is the same as ov2680 driver (OVTI2680) which
> is very similar to ov5648. As reported by dmesg, atomisp-gmin-platform fails
> to load CamClk, ClkSrc, CsiPort, CsiLanes variables from ACPI (although they
> are set as showed by DSDT) and it fails to get regulators. My Miix 310 uses
> AXP PMIC (INT33F4:00) which, as far as I can understand by looking at
> 01org/ProductionKernelQuilts code, it's yet not supported by mainline kernel.

Hmm. In other words this driver isn't usable due to lack of other drivers.
Even if they'd be in place, this hasn't been tested. What would be the
likelihood of it functioning in the end?

Would it make sense to first get the other drivers to upstream and then see
what's the status of atomisp? The atomisp driver has a number of entries in
its TODO file, one of which is making the sensor drivers to use the
standard kernel interfaces to work with the main driver (atomisp), so that
they could be used with any ISP / bridge driver.

Also, the interface the atomisp uses with the sensor drivers as well as how
the board specific information from firmware is conveyed to the sensor
drivers will change to what the rest of the sensor drivers are using. I
think a most straightforward way would be to amend the ACPI tables to
include the necessary information.

Therefore, applying this patch would not have an effective improvement to
the users in form of support for new systems and would make the upcoming
interface changes more difficult as there would be one more driver to
change (and test).

For this reason I'm tempted to postpone applying this patch at least until
the other drivers are available.

Andy, Alan; any opinion?

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
