Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54688 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754092Ab2JOSfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 14:35:50 -0400
Date: Mon, 15 Oct 2012 21:35:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Vincent ABRIOU <vincent.abriou@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	Nicolas THERY <nicolas.thery@st.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>
Subject: Re: [PATCH RFC 1/5] V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media
 bus format
Message-ID: <20121015183517.GF21261@valkosipuli.retiisi.org.uk>
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
 <1348498546-2652-2-git-send-email-s.nawrocki@samsung.com>
 <2823843.qYtB3rcnKu@avalon>
 <5061C23E.903@samsung.com>
 <9481210134BDC5419AC503D05B6CA44F34B780C91A@SAFEX1MAIL1.st.com>
 <50745A66.1050708@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <50745A66.1050708@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester and Vincent,

My apologies for the late reply on this topic. I've been quite busy lately.

Sylwester Nawrocki wrote:
> On 10/09/2012 03:36 PM, Vincent ABRIOU wrote:
>> Hi Sylwester,
>>
>> I'm wondering why don't you simply define V4L2_MBUS_FMT_UYVY_JPEG_1X8
>> without any reference to your camera?
>
> Because it's not a plain UYVY/JPEG data. There is an additional meta-data
> that follows interleaved UYVY/JPEG. It's all on a single User Defined
> MIPI CSI-2 DT. In addition to that there is some more meta data transmitted
> on MIPI CSI-2 Embedded Data DT. If there was no meta-data present at the
> User Defined DT, then we could think about using generic
> V4L2_MBUS_FMT_UYVY_JPEG_1X8 pixel code and handling the meta-data on
> separate DT with the frame_desc calls.
>
> Anyway this S5C media bus format is an experimental thing and if there are
> cameras generating plain JPEG/YUV we need to search for better, more generic
> solution.

Vincent: what's the frame layout that your sensor produces? There are two
cases that could be easy (sort of, everything's relative) that I can see for
the standard interfaces.

1. Different parts of the image are transmitted over different CSI-2
contexts. This way the receiver may separate them to separate memory
regions, and the end result is a single multi-plane buffer.

2. If the distance in octets of the intermittent image strides is constant,
then we could do some tricks with multi-plane buffers. The two planes of the
buffer could be interleaved, with correct base addresses.

I think Sylwester's case fits into neither of the above. A device-specific
format does not resolve configuring the two formats.

Both require adding plane-specific pixel codes, agreement over how frame
descriptors are used for describing frames of multiple independent content
planes, and how the multiple formats are configured on the sensor. Use of
sub-subdevs come to mind for the last one as an alternative --- this issue
stems from the fact we're using the same interface to model the bus and the
image format on that bus. It no longer works out the way it used to when
there are two formats on the same bus.

Each of these probably require a separate RFC and someone to implement the
changes.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
