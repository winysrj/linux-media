Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46622 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753763Ab2IWNSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 09:18:42 -0400
Message-ID: <505F0C86.9070206@iki.fi>
Date: Sun, 23 Sep 2012 16:20:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
In-Reply-To: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Prabhakar Lad wrote:
> Hi All,
>
> The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
> B/Mg gain values.
> Since these control can be re-usable I am planning to add the
> following gain controls as part
> of the framework:
>
> 1: V4L2_CID_GAIN_RED
> 2: V4L2_CID_GAIN_GREEN_RED
> 3: V4L2_CID_GAIN_GREEN_BLUE
> 4: V4L2_CID_GAIN_BLUE
> 5: V4L2_CID_GAIN_OFFSET
>
> I need your opinion's to get moving to add them.

I think these controls can fit under the image processing controls class 
--- image processing and not image source since these can also have a 
digital implementation e.g. in an ISP.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
