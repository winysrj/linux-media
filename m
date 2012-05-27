Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2E0RNl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 13:13:41 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4RHDfaR000568
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 27 May 2012 13:13:41 -0400
Message-ID: <4FC260C2.3060802@redhat.com>
Date: Sun, 27 May 2012 14:13:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve
 Kconfig selection for media devices
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1338137803-12231-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-05-2012 13:56, Mauro Carvalho Chehab escreveu:
> The Kconfig building system is improperly selecting some drivers,
> like analog TV tuners even when this is not required.
> 
> Rearrange the Kconfig in a way to prevent that.
> 
> Mauro Carvalho Chehab (3):
>   media: reorganize the main Kconfig items
>   media: Remove VIDEO_MEDIA Kconfig option
>   media: only show V4L devices based on device type selection
> 
>  drivers/media/Kconfig               |  114 +++++++++++++++++++++++------------
>  drivers/media/common/tuners/Kconfig |   64 ++++++++++----------
>  drivers/media/dvb/frontends/Kconfig |    1 +
>  drivers/media/radio/Kconfig         |    1 +
>  drivers/media/rc/Kconfig            |   29 ++++-----
>  drivers/media/video/Kconfig         |   76 +++++++++++++++++------
>  drivers/media/video/m5mols/Kconfig  |    1 +
>  drivers/media/video/pvrusb2/Kconfig |    1 -
>  drivers/media/video/smiapp/Kconfig  |    1 +
>  9 files changed, 181 insertions(+), 107 deletions(-)
> 

The organization between DVB only, V4L only and hybrid devices are somewhat
confusing on our tree. From time to time, someone proposes changing one driver
from one place to another or complains that "his device is DVB only but it is
inside the V4L tree" (and other similar requests). This sometimes happen because
the same driver can support analog only, digital only or hybrid devices.

Also, one driver may start as a DVB only or as a V4L only and then 
it can be latter be converted into an hybrid driver.

So, the better is to rearrange the drivers tree, in order to fix this issue,
removing them from /video and /dvb, and storing them on a better place.

So, my proposal is to move all radio, analog TV, digital TV, webcams and grabber
bridge drivers to this arrangement:

drivers/media/isa - ISA drivers
drivers/media/usb - USB drivers
drivers/media/pci - PCI/PCIe drivers
drivers/media/platform - platform drivers

Comments?

Regards,
Mauro

-

PS.: for now, I don't intend to touch at I2C/ancillary drivers. We may latter move
the i2c drivers that aren't frontend/tuners to media/i2c or to media/common.
