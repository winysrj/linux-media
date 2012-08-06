Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60883 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab2HFJho (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 05:37:44 -0400
Message-ID: <501F903A.3070700@ti.com>
Date: Mon, 6 Aug 2012 15:06:58 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR v3.6-rc1] Mediabus And Pixel format supported by
 DM365
References: <501F6F13.8090401@ti.com>
In-Reply-To: <501F6F13.8090401@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Sorry, the subject of course should have been "GIT PULL FOR v3.7"

Thx,
--Prabhakar

On Monday 06 August 2012 12:45 PM, Prabhakar Lad wrote:
> Hi Mauro,
> 
> Can you please pull the following patches, which add medibus and pixel
> format supported by DM365.
> 
> Thanks and Regards,
> --Prabhakar Lad
> 
> 
> The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:
> 
>   Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)
> 
> are available in the git repository at:
>   git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git mc_dm365_mbus_fmt
> 
> Manjunath Hadli (2):
>       media: add new mediabus format enums for dm365
>       v4l2: add new pixel formats supported on dm365
> 
>  .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +++
>  Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 +++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
>  Documentation/DocBook/media/v4l/subdev-formats.xml |  250
> +++++++++++++++++++-
>  include/linux/v4l2-mediabus.h                      |   10 +-
>  include/linux/videodev2.h                          |    8 +
>  6 files changed, 358 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

