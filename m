Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51803 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab2KEUrE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 15:47:04 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3203350eek.19
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2012 12:47:02 -0800 (PST)
Message-ID: <509825C4.9000604@gmail.com>
Date: Mon, 05 Nov 2012 21:47:00 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Alain VOLMAT <alain.volmat@st.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Way to request a time discontinuity in a V4L2 encoder device
References: <E27519AE45311C49887BE8C438E68FAA01012DC87FE3@SAFEX1MAIL1.st.com> <2626505.HXeeK07UU3@avalon> <E27519AE45311C49887BE8C438E68FAA01012DD27186@SAFEX1MAIL1.st.com>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA01012DD27186@SAFEX1MAIL1.st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/05/2012 11:45 AM, Alain VOLMAT wrote:
> Hi Laurent,
>
> Yes indeed, meta plane seems a good candidate. It was the other option.
>
> The pity with that is that the FMT can thus no longer be standard FMT but
>  a specific format that include both plane 0 with real frame data and plane
>1 with meta data.
> So, standard V4L2 application (that doesn't know about this time
>discontinuity stuff) wouldn't be able to push things into the encoder since
>they are not aware of this 2 plane format.
>
> Or maybe we should export 2 format, 1 standard one that doesn't have time
>discontinuity support, thus not best performance but still can do things
>and a second format that has 2 planes

Not sure what media guys think about it, I was considering making it 
possible
for applications (or libv4l or any other library) to request additional 
meta
data plane at a video capture driver, e.g. with VIDIOC_S_FMT ioctl. With 
same
fourcc for e.g. 1-planar buffers with image data and 2-planar buffer with
meta data in plane 1. However this would be somehow device-specific, rather
than a completely generic interface. Since frame-meta data is often device
specific. For camera it would depend on the image sensor whether the 
additional
plane request on a /dev/video? would be fulfilled by a driver or not.

I don't think duplicating 4CCs for the sake of additional meta-data plane is
a good idea.

Your case is a bit different, since you're passing data from application to
a device. Maybe we could somewhat standardize the meta data buffer content,
e.g. by using some standard header specifying what kind of meta data 
follows.
Perhaps struct v4l2_plane::data_offset can be helpful here. This is how 
it's
documented

  * @data_offset:	offset in the plane to the start of data; usually 0,
  *			unless there is a header in front of the data

I mean, the header would specify what actual meta-data is in that additional
plane. Standardising that "standard" meta-data would be another issue.

I think this per buffer device control issue emerged in the past during the
Exynos Multi Format Codec development. There were proposals of per-buffer
v4l2 controls. IIRC it is currently resolved in that driver by doing
VIDIOC_S_CTRL before QBUF. However the meta data plane approach looks more
interesting to me.

--

Regards,
Sylwester
