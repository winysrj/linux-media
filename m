Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:13334 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751420AbdJJLte (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:49:34 -0400
Date: Tue, 10 Oct 2017 14:49:29 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Devid Antonio Filoni <d.filoni@ubuntu.com>,
        andriy.shevchenko@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?iso-8859-1?B?Suly6W15?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v4] staging: atomisp: add a driver for ov5648 camera
 sensor
Message-ID: <20171010114929.yfo5knj5w6qpp2qy@paasikivi.fi.intel.com>
References: <1507073092-11936-1-git-send-email-d.filoni@ubuntu.com>
 <20171006125716.txmwvuhhxdw2fyji@paasikivi.fi.intel.com>
 <1507626520.26339.9.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1507626520.26339.9.camel@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Tue, Oct 10, 2017 at 10:08:40AM +0100, Alan Cox wrote:
> > Would it make sense to first get the other drivers to upstream and
> > then see what's the status of atomisp? 
> 
> Agreed
> 
> > the board specific information from firmware is conveyed to the
> > sensor drivers will change to what the rest of the sensor drivers are
> > using. I think a most straightforward way would be to amend the ACPI
> > tables to include the necessary information.
> 
> I don't see that happening. The firmware they have today is the
> firmware they will always have, and for any new devices we manage to
> get going is probably going to end up entirely hardcoded.

You'd need to pass the table use initrd to amend the existing tables.

Another option would be to parse the information from ACPI / EFI variables
or whatever to set things up in the atomisp driver, and rely on e.g. I²C
matching in the V4L2 async framework.

The board specific information needed by the sensor drivers need to be
somehow conveyed to the drivers. Perhaps using pset /
device_add_property()?

This is not trivial and would require at least either V4L2 framework or
sensor driver changes to support atomisp, which currently is a staging
driver.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
