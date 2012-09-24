Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab2IXKzB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 06:55:01 -0400
Message-ID: <50603C39.9060105@redhat.com>
Date: Mon, 24 Sep 2012 12:55:53 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
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

Hi,

On 09/23/2012 01:26 PM, Prabhakar Lad wrote:
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

Not all sensors have separate V4L2_CID_GAIN_GREEN_RED / V4L2_CID_GAIN_GREEN_BLUE,
so we will need a separate control for sensors which have one combined gain
called simply V4L2_CID_GAIN_GREEN

Also do we really need separate V4L2_CID_GAIN_GREEN_RED / V4L2_CID_GAIN_GREEN_BLUE
controls? I know hardware has them, but in my experience that is only done as it
is simpler to make the hardware this way (fully symmetric sensor grid), have you ever
tried actually using different gain settings for the 2 different green rows ?

I've and that always results in an ugly checker board pattern. So I think we can
and should only have a V4L2_CID_GAIN_GREEN, and for sensors with 2 green gains
have that control both, forcing both to always have the same setting, which is
really what you want anyways ...

> 4: V4L2_CID_GAIN_BLUE
> 5: V4L2_CID_GAIN_OFFSET

GAIN_OFFSET that sounds a bit weird... GAIN_OFFSET sounds like it is
a number which gets added to the 3/4 gain settings before the gain gets applied,
but I assume that you just mean a number which gets added to the value from
the pixel, either before or after the gain is applied and I must admit I cannot
come up with a better name.

I believe (not sure) that some sensors have these per color ... The question
is if it makes sense to actually control this per color though, I don't think it
does as it is meant to compensate for any fixed measuring errors, which are the
same for all 3/4 colors. Note that all the sensor cells are exactly the same,
later on a color grid gets added on top of the sensors to turn them into r/g/b
cells, but physically they are the same cells, so with the same process and
temperature caused measuring errors...

Regards,

Hans
