Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19010 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751826AbdJJJIo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 05:08:44 -0400
Message-ID: <1507626520.26339.9.camel@linux.intel.com>
Subject: Re: [PATCH v4] staging: atomisp: add a driver for ov5648 camera
 sensor
From: Alan Cox <alan@linux.intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Devid Antonio Filoni <d.filoni@ubuntu.com>
Cc: andriy.shevchenko@linux.intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?J=E9r=E9my?= Lefaure <jeremy.lefaure@lse.epita.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Tue, 10 Oct 2017 10:08:40 +0100
In-Reply-To: <20171006125716.txmwvuhhxdw2fyji@paasikivi.fi.intel.com>
References: <1507073092-11936-1-git-send-email-d.filoni@ubuntu.com>
         <20171006125716.txmwvuhhxdw2fyji@paasikivi.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Would it make sense to first get the other drivers to upstream and
> then see what's the status of atomisp? 

Agreed

> the board specific information from firmware is conveyed to the
> sensor drivers will change to what the rest of the sensor drivers are
> using. I think a most straightforward way would be to amend the ACPI
> tables to include the necessary information.

I don't see that happening. The firmware they have today is the
firmware they will always have, and for any new devices we manage to
get going is probably going to end up entirely hardcoded.

> For this reason I'm tempted to postpone applying this patch at least
> until the other drivers are available.

Yes - unless someone has a different controller and that sensor on a
board so can test it that way ?

Alan
