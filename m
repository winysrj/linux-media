Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57351 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2BEAgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 19:36:04 -0500
Received: by eekc14 with SMTP id c14so1694410eek.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 16:36:03 -0800 (PST)
Message-ID: <4F2DCEF0.5070701@gmail.com>
Date: Sun, 05 Feb 2012 01:36:00 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain> <4F2924F8.3040408@samsung.com> <4F2D14ED.8080105@iki.fi> <4F2D4E2D.1030107@gmail.com> <4F2D5231.4000703@iki.fi> <4F2D79A9.8030504@gmail.com> <Pine.LNX.4.64.1202050041001.3770@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1202050041001.3770@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2012 12:44 AM, Guennadi Liakhovetski wrote:
>> Yes, this is what I started with. What do you think about creating media

Actually now I have something like V4L2_MBUS_FMT_VYUY_JPEG_I1_1X8 
(I1 indicating interleaving method), so it is not so tightly tied 
to a particular sensor. 

>> bus codes directly corresponding the the user defined MIPI-CSI data types ?
> 
> We've discussed this before with Laurent, IIRC, and the decision was, that
> since a "typical" CSI-2 configuration includes a CSI-2 phy, interfacing to
> a "standard" bridge, that can also receive parallel data directly, and the
> phy normally has a 1-to-1 mapping from CSI-2 formats to mediabus codes,
> so, we can just as well directly use respective mediabus codes to
> configure CSI-2 phys.

OK. The 1-to-1 mapping is true only for MIPI-CSI defined image formats AFAICS.
Let's take JPEG as an example, AFAIU there is nothing in the standard indicating
which User Defined Data Type should be used for JPEG. If some bridge/sensor pair
uses User1 for V4L2_MBUS_FMT_JPEG_1X8 and other uses User2 then there is no way
to make any of these sensors work with any bridge without code modifications. 
Looks like we would need MIPI-CSI DT field in format description data structure 
((like) struct soc_mbus_lookup).

--

Thanks,
Sylwester
