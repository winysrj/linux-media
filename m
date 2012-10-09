Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38399 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2JIRKC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 13:10:02 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBM00461YDB6PC0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Oct 2012 18:10:23 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MBM001ZUYCN6E20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Oct 2012 18:10:00 +0100 (BST)
Message-id: <50745A66.1050708@samsung.com>
Date: Tue, 09 Oct 2012 19:09:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Vincent ABRIOU <vincent.abriou@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	"sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
	Nicolas THERY <nicolas.thery@st.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>,
	Willy POISSON <willy.poisson@st.com>
Subject: Re: [PATCH RFC 1/5] V4L: Add V4L2_MBUS_FMT_S5C_UYVY_JPEG_1X8 media bus
 format
References: <1348498546-2652-1-git-send-email-s.nawrocki@samsung.com>
 <1348498546-2652-2-git-send-email-s.nawrocki@samsung.com>
 <2823843.qYtB3rcnKu@avalon> <5061C23E.903@samsung.com>
 <9481210134BDC5419AC503D05B6CA44F34B780C91A@SAFEX1MAIL1.st.com>
In-reply-to: <9481210134BDC5419AC503D05B6CA44F34B780C91A@SAFEX1MAIL1.st.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vincent,

On 10/09/2012 03:36 PM, Vincent ABRIOU wrote:
> Hi Sylwester,
> 
> I'm wondering why don't you simply define V4L2_MBUS_FMT_UYVY_JPEG_1X8
> without any reference to your camera?

Because it's not a plain UYVY/JPEG data. There is an additional meta-data
that follows interleaved UYVY/JPEG. It's all on a single User Defined 
MIPI CSI-2 DT. In addition to that there is some more meta data transmitted 
on MIPI CSI-2 Embedded Data DT. If there was no meta-data present at the
User Defined DT, then we could think about using generic 
V4L2_MBUS_FMT_UYVY_JPEG_1X8 pixel code and handling the meta-data on 
separate DT with the frame_desc calls.

Anyway this S5C media bus format is an experimental thing and if there are
cameras generating plain JPEG/YUV we need to search for better, more generic
solution.

> Indeed, many other cameras could support Jpeg interleaved with YUV and it will
> avoid to define a new media bus type for every cameras integrated under V4L2
> supporting JPEG/YUV interleaving feature.

Yes, we also need some interface to configure both streams, e.g. image
resolutions independently. Still having separate pixel codes for pairs of
JPEG and something else seems not optimal. Nevertheless I can't think of
any better solution right now, so applications are able to configure
selected format at a camera subdev.

I'm also wondering what are the interleaving methods in case of various
cameras. Even though they interleave same 2 standard formats, the way how
the interleaving happens could differ, couldn't it ? Such information
probably cannot be easily contained in the meta-data, unless there is some
standard (header) format for it. 

> Thank you for your feedback.
> 
> Regards,
> --
> Vincent Abriou

--

Regards,
Sylwester
