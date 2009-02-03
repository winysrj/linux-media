Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:58409 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbZBCKUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2009 05:20:10 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Dongsoo Kim <dongsoo.kim@gmail.com>
Subject: Re: [V4L2] EV control API for digital camera
Date: Tue, 3 Feb 2009 11:20:01 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	=?euc-kr?q?=C7=FC=C1=D8_=B1=E8?= <riverful.kim@samsung.com>,
	jongse.won@samsung.com, kyungmin.park@samsung.com
References: <5e9665e10901281824ibccbf00lcbecba5b01fdcbea@mail.gmail.com> <Pine.LNX.4.64.0901291934300.5474@axis700.grange> <B44B29E7-9C46-4F34-8CE4-AB17D6CCBCB7@gmail.com>
In-Reply-To: <B44B29E7-9C46-4F34-8CE4-AB17D6CCBCB7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031120.01937.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nate,

On Thursday 29 January 2009, Dongsoo Kim wrote:
> Thank you.
>
> So if V4L2_CID_EXPOSURE is for Exposure Value control, I think there
> is no api for exposure metering. right?

V4L2_CID_EXPOSURE controls the exposure time. This is often implemented 
through a mechanical or electronic shutter in the device.

What kind of exposure metering do you have in mind ? Can you give us some 
details ?

> Actually many of APIs for camera are missing I guess.

You're probably right. The V4L1/V4L2 API have been developed for frame 
grabbers and extended to webcams. Now that high-end digital cameras get USB 
connectivity, the V4L2 API should be extended with new controls. Feel free to 
submit proposals for discussion on the linux-media mailing list.

Best regards,

Laurent Pinchart
