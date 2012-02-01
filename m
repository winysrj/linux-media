Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45948 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2BAKAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2012 05:00:13 -0500
Date: Wed, 1 Feb 2012 12:00:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
Message-ID: <20120201100007.GA841@valkosipuli.localdomain>
References: <4F27CF29.5090905@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F27CF29.5090905@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Tue, Jan 31, 2012 at 12:23:21PM +0100, Sylwester Nawrocki wrote:
> Hi all,
> 
> Some camera sensors generate data formats that cannot be described using
> current convention of the media bus pixel code naming.
> 
> For instance, interleaved JPEG data and raw VYUY. Moreover interleaving
> is rather vendor specific, IOW I imagine there might be many ways of how
> the interleaving algorithm is designed.

Is that truly interleaved, or is that e.g. first yuv and then jpeg?
Interleaving the two sounds quite strange to me.

> I'm wondering how to handle this. For sure such an image format will need
> a new vendor-specific fourcc. Should we have also vendor specific media bus code ?
> 
> I would like to avoid vendor specific media bus codes as much as possible.
> For instance defining something like
> 
> V4L2_MBUS_FMT_VYUY_JPEG_1X8
> 
> for interleaved VYUY and JPEG data might do, except it doesn't tell anything
> about how the data is interleaved.
> 
> So maybe we could add some code describing interleaving (xxxx)
> 
> V4L2_MBUS_FMT_xxxx_VYUY_JPEG_1X8
> 
> or just the sensor name instead ?

If that format is truly vendor specific, I think a vendor or sensor specific
media bus code / 4cc would be the way to go. On the other hand, you must be
prepared to handle these formats in your ISP driver, too.

I'd guess that all the ISP would do to such formats is to write them to
memory since I don't see much use for either in ISPs --- both typically are
output of the ISP.

I think we will need to consider use cases where the sensors produce other
data than just the plain image: I've heard of a sensor producing both
(consecutively, I understand) and there are sensors that produce metadata as
well. For those, we need to specify the format of the full frame, not just
the image data part of it --- which we have called "frame" at least up to
this point.

If the case is that the ISP needs this kind of information from the sensor
driver to be able to handle this kind of data, i.e. to write the JPEG and
YUV to separate memory locations, I'm proposing to start working on this
now rather than creating a single hardware-specific solution.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
