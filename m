Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:42905 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZCRQR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 12:17:58 -0400
Received: by rv-out-0506.google.com with SMTP id f9so73348rvb.1
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2009 09:17:56 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 18 Mar 2009 21:47:56 +0530
Message-ID: <d9ec170c0903180917k691f9d01pe4cb4231efe282e4@mail.gmail.com>
Subject: ISP Configuration for RAW Bayer sensor
From: Suresh Rao <sureshraomr@gmail.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, saaguirre@ti.com,
	hvaibhav@ti.com, tuukka.o.toivonen@nokia.com,
	klimov.linux@gmail.com, david.cohen@nokia.com,
	antti.koskipaa@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working with MT9V023 RAW sensor.  The data format from the sensor is

B G B G B G B G ...
G R G R G R G R ...
B G B G B G B G ...
G R G R G R G R ........      [ Format 1]

The sources I am using for ISP drivers are pulled on top of
linux-omap-2.6.29-rc7 from [git pull
git://git.gitorious.org/omap3camera/mainline.git v4l iommu omap3camera
base].

I want to use the ISP on the OMAP for doing interpolation and format
conversion to UYVY.  I am able to capture the images from the sensor,
however I notice that the color information is missing.  I dug the
sources and found that in the RAW capture mode ISP is getting
configured to input format

G R G R G R G R ...
B G B G B G B G ...
G R G R G R G R ...
B G B G B G B G ...          [Format 2]

Has anyone tried sensors with BGGR ( Format 1) on OMAP?

Can anyone give me some pointers or information on how to configure
ISP for BGGR (Format 1)

Thanks in advance for all the help.

Thanks,
Suresh
