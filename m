Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43395 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752648Ab2IOMUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 08:20:00 -0400
Message-ID: <505472BD.8090405@iki.fi>
Date: Sat, 15 Sep 2012 15:21:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Nicolas THERY <nicolas.thery@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>,
	Benjamin GAIGNARD <benjamin.gaignard@st.com>,
	Vincent ABRIOU <vincent.abriou@st.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: how to crop/scale in mono-subdev camera sensor driver?
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com> <50534688.7010805@st.com> <50539B6C.2060400@gmail.com>
In-Reply-To: <50539B6C.2060400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Nicolas,

Sylwester Nawrocki wrote:
> Hi,
>
> On 09/14/2012 05:00 PM, Nicolas THERY wrote:
>> Hello,
>>
>> I'm studying how to support cropping and scaling (binning, skipping, digital
>> scaling if any) for different models for camera sensor drivers.  There seems to
>> be (at least) two kinds of sensor drivers:
>>
>> 1) The smiapp driver has 2 or 3 subdevs: pixel array ->  binning (->  scaling).
>> It gives clients full control over the various ways of cropping and scaling
>> thanks to the selection API.
>>
>> 2) The mt9p031 driver (and maybe others) has a single subdev.  Clients use the
>> obsolete SUBDEV_S_CROP ioctl for selecting a region of interest in the pixel
>> array and SUBDEV_S_FMT for setting the source pad mbus size.  If the mbus size
>> differs from the cropping rectangle size, scaling is enabled and the driver
>> decides internally how to combine skipping and binning to achieve the requested
>> scaling factors.
>>
>> As SUBDEV_S_CROP is obsolete, I wonder whether it is okay to support cropping
>> and scaling in a mono-subdev sensor driver by (a) setting the cropping
>> rectangle with SUBDEV_S_SELECTION on the source pad, and (b) setting the
>> scaling factors via the source pad mbus size as in the mt9p031 driver?
>
> Cc: Sakari, Laurent
>
> AFAICT in a single subdev with one pad configuration your steps as above
> are valid, i.e. crop rectangle can be set with
> VIDIOC_SUBDEV_S_SELECTION(V4L2_SEL_TGT_CROP) and the sensor's output
> resolution with VIDIOC_SUBDEV_S_FMT.
>
> I guess documentation [1] wasn't clear enough about that ?
>
> The subdev crop ioctls are deprecated in favour of the selection API, so
> now VIDIOC_SUBDEV_G/S_SELECTION ioctls and corresponding subdev ops needs
> to be used anywhere you would have used SUBDEV_G/S_CROP before.
>
> This reminds me there are still a few drivers that need to be converted
> to use set/get_selection subdev pad level ops, rather than set/get_crop.
>
> [1] http://linuxtv.org/downloads/v4l-dvb-apis/subdev.html

After the selection IOCTLs were implemented for the subdev API, the 
subdev API then allowed explicitly configuring cropping after scaling 
inside a single subdev, among other improvements.

Before the introduction of the selection extensions, the subdev API has 
never allowed explicitly performing scaling and cropping using a single 
subdev with only a single source pad but still some sensor drivers 
implement it this way. It may well be that it is technically possible to 
use the source pad media bus format to configure scaling after cropping 
but that's against what's currently defined in the spec, for the reason 
that we wanted to define explicitly which selection targets are used for 
configuring cropping and scaling and in which order that configuration 
is expected to be done, in order to be able to configure the subdev 
without having to know anything else about it except that it implements 
the selection API. The scaler in the ISP can now be configured using 
exactly the same API as can the scaler in the sensor.

If you wish to expose the scaling configuration of the sensor using the 
V4L2 subdev interface, then I suggest doing what the SMIA++ driver does: 
multiple subdevs. See "Order of configuration and format propagation" 
behind the above URL.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
