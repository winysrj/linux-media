Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:36671 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531Ab2INPA3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 11:00:29 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1D8CBC7
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 15:00:26 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas5.st.com [10.75.90.71])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id BA2BF4A6A
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 15:00:26 +0000 (GMT)
From: Nicolas THERY <nicolas.thery@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>,
	Benjamin GAIGNARD <benjamin.gaignard@st.com>,
	Vincent ABRIOU <vincent.abriou@st.com>
Date: Fri, 14 Sep 2012 17:00:24 +0200
Subject: how to crop/scale in mono-subdev camera sensor driver?
Message-ID: <50534688.7010805@st.com>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm studying how to support cropping and scaling (binning, skipping, digital
scaling if any) for different models for camera sensor drivers.  There seems to
be (at least) two kinds of sensor drivers:

1) The smiapp driver has 2 or 3 subdevs: pixel array -> binning (-> scaling).
It gives clients full control over the various ways of cropping and scaling 
thanks to the selection API.

2) The mt9p031 driver (and maybe others) has a single subdev.  Clients use the
obsolete SUBDEV_S_CROP ioctl for selecting a region of interest in the pixel
array and SUBDEV_S_FMT for setting the source pad mbus size.  If the mbus size
differs from the cropping rectangle size, scaling is enabled and the driver
decides internally how to combine skipping and binning to achieve the requested
scaling factors.

As SUBDEV_S_CROP is obsolete, I wonder whether it is okay to support cropping
and scaling in a mono-subdev sensor driver by (a) setting the cropping
rectangle with SUBDEV_S_SELECTION on the source pad, and (b) setting the
scaling factors via the source pad mbus size as in the mt9p031 driver?

Thanks in advance.

Best regards,
Nicolas