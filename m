Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44639 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2INVCl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 17:02:41 -0400
Received: by bkwj10 with SMTP id j10so1461682bkw.19
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 14:02:40 -0700 (PDT)
Message-ID: <50539B6C.2060400@gmail.com>
Date: Fri, 14 Sep 2012 23:02:36 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Nicolas THERY <nicolas.thery@st.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>,
	Benjamin GAIGNARD <benjamin.gaignard@st.com>,
	Vincent ABRIOU <vincent.abriou@st.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: how to crop/scale in mono-subdev camera sensor driver?
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com> <50534688.7010805@st.com>
In-Reply-To: <50534688.7010805@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/14/2012 05:00 PM, Nicolas THERY wrote:
> Hello,
> 
> I'm studying how to support cropping and scaling (binning, skipping, digital
> scaling if any) for different models for camera sensor drivers.  There seems to
> be (at least) two kinds of sensor drivers:
> 
> 1) The smiapp driver has 2 or 3 subdevs: pixel array ->  binning (->  scaling).
> It gives clients full control over the various ways of cropping and scaling
> thanks to the selection API.
> 
> 2) The mt9p031 driver (and maybe others) has a single subdev.  Clients use the
> obsolete SUBDEV_S_CROP ioctl for selecting a region of interest in the pixel
> array and SUBDEV_S_FMT for setting the source pad mbus size.  If the mbus size
> differs from the cropping rectangle size, scaling is enabled and the driver
> decides internally how to combine skipping and binning to achieve the requested
> scaling factors.
> 
> As SUBDEV_S_CROP is obsolete, I wonder whether it is okay to support cropping
> and scaling in a mono-subdev sensor driver by (a) setting the cropping
> rectangle with SUBDEV_S_SELECTION on the source pad, and (b) setting the
> scaling factors via the source pad mbus size as in the mt9p031 driver?

Cc: Sakari, Laurent

AFAICT in a single subdev with one pad configuration your steps as above 
are valid, i.e. crop rectangle can be set with 
VIDIOC_SUBDEV_S_SELECTION(V4L2_SEL_TGT_CROP) and the sensor's output 
resolution with VIDIOC_SUBDEV_S_FMT.

I guess documentation [1] wasn't clear enough about that ?

The subdev crop ioctls are deprecated in favour of the selection API, so
now VIDIOC_SUBDEV_G/S_SELECTION ioctls and corresponding subdev ops needs 
to be used anywhere you would have used SUBDEV_G/S_CROP before.

This reminds me there are still a few drivers that need to be converted
to use set/get_selection subdev pad level ops, rather than set/get_crop.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html

--

Regards,
Sylwester
