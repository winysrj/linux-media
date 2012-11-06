Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:59352 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab2KFKCz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 05:02:55 -0500
From: Vincent ABRIOU <vincent.abriou@st.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	Nicolas THERY <nicolas.thery@st.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>
Date: Tue, 6 Nov 2012 11:02:22 +0100
Subject: RE: [PATCH RFC 1/5] V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media
 bus format
Message-ID: <9481210134BDC5419AC503D05B6CA44F34B8BC7CCD@SAFEX1MAIL1.st.com>
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
 <1348498546-2652-2-git-send-email-s.nawrocki@samsung.com>
 <2823843.qYtB3rcnKu@avalon> <5061C23E.903@samsung.com>
 <9481210134BDC5419AC503D05B6CA44F34B780C91A@SAFEX1MAIL1.st.com>
 <50745A66.1050708@samsung.com>
 <20121015183517.GF21261@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121015183517.GF21261@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari and Sylwester,

Sorry for the late answer.

> -----Original Message-----
> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Monday, October 15, 2012 8:36 PM
> To: Sylwester Nawrocki
> Cc: Vincent ABRIOU; linux-media@vger.kernel.org; a.hajda@samsung.com;
> Laurent Pinchart; hverkuil@xs4all.nl; kyungmin.park@samsung.com;
> sw0312.kim@samsung.com; Nicolas THERY; Jean-Marc VOLLE; Pierre-yves
> TALOUD; Willy POISSON
> Subject: Re: [PATCH RFC 1/5] V4L: Add
> V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus format
> 
> Hi Sylwester and Vincent,
> 
> My apologies for the late reply on this topic. I've been quite busy lately.
> 
> Sylwester Nawrocki wrote:
> > On 10/09/2012 03:36 PM, Vincent ABRIOU wrote:
> >> Hi Sylwester,
> >>
> >> I'm wondering why don't you simply define
> V4L2_MBUS_FMT_UYVY_JPEG_1X8
> >> without any reference to your camera?
> >
> > Because it's not a plain UYVY/JPEG data. There is an additional
> > meta-data that follows interleaved UYVY/JPEG. It's all on a single
> > User Defined MIPI CSI-2 DT. In addition to that there is some more
> > meta data transmitted on MIPI CSI-2 Embedded Data DT. If there was no
> > meta-data present at the User Defined DT, then we could think about
> > using generic
> > V4L2_MBUS_FMT_UYVY_JPEG_1X8 pixel code and handling the meta-data
> on
> > separate DT with the frame_desc calls.
> >
> > Anyway this S5C media bus format is an experimental thing and if there
> > are cameras generating plain JPEG/YUV we need to search for better,
> > more generic solution.
> 
> Vincent: what's the frame layout that your sensor produces? There are two
> cases that could be easy (sort of, everything's relative) that I can see for the
> standard interfaces.

The sensor I used interleaved Jpeg and YUV but I met 2 cases:
1/ sensor providing JPEG / YUV (using the same DT)
2/ sensor providing JPEG with a 1st DT, YUV with a 2nd DT and embedded data using a 3rd DT

> 
> 1. Different parts of the image are transmitted over different CSI-2 contexts.
> This way the receiver may separate them to separate memory regions, and
> the end result is a single multi-plane buffer.
> 
> 2. If the distance in octets of the intermittent image strides is constant, then
> we could do some tricks with multi-plane buffers. The two planes of the
> buffer could be interleaved, with correct base addresses.
> 
> I think Sylwester's case fits into neither of the above. A device-specific
> format does not resolve configuring the two formats.
> 
> Both require adding plane-specific pixel codes, agreement over how frame
> descriptors are used for describing frames of multiple independent content
> planes, and how the multiple formats are configured on the sensor. Use of
> sub-subdevs come to mind for the last one as an alternative --- this issue
> stems from the fact we're using the same interface to model the bus and the
> image format on that bus. It no longer works out the way it used to when
> there are two formats on the same bus.
> 

My point of view is that the only user's concern is how to retrieve the data, on which pad and how are they sorted?

The MBUS format to be use by the camera (and set by the user) should only define the overall structure of the CSI stream and could be generic (like V4L2_MBUS_FMT_UYVY_JPEG_1X8  or V4L2_MBUS_FMT_YUYV_JPEG_1X8 without any sensor model mentioned).
In the MBUS format naming, we don't care about describing the eventual metadata and other stream specificities link to the camera because the CSI stream details could be described in the v4l2_subdev_frame_format as initially proposed by Sakari (More flag descriptor could be added to describe the data to be transmitted).
It is then up to the CSI2 receiver to recover the CSI stream layout and to configure output pads and multi-plane buffer according to its capabilities. Multi-plan buffer attached to the pad need to have a plane-specific pixel code in order to warn user about the buffer content.
Then user could query the output pads of the CSI 2 receiver to discover on which pad the different pixel formats are outputted and how:

> Each of these probably require a separate RFC and someone to implement
> the changes.
> 
> Kind regards,
> 
> --
> Sakari Ailus
> sakari.ailus@iki.fi

Best Regards,

Vincent Abriou
