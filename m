Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46653 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751684Ab2IWQZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 12:25:37 -0400
Message-ID: <505F3857.50603@iki.fi>
Date: Sun, 23 Sep 2012 19:27:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com> <505F0C86.9070206@iki.fi> <3579105.beYuXk8XyG@avalon>
In-Reply-To: <3579105.beYuXk8XyG@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi,
>
> On Sunday 23 September 2012 16:20:06 Sakari Ailus wrote:
>> Prabhakar Lad wrote:
>>> Hi All,
>>>
>>> The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
>>> B/Mg gain values.
>>> Since these control can be re-usable I am planning to add the
>>> following gain controls as part
>>> of the framework:
>>>
>>> 1: V4L2_CID_GAIN_RED
>>> 2: V4L2_CID_GAIN_GREEN_RED
>>> 3: V4L2_CID_GAIN_GREEN_BLUE
>>> 4: V4L2_CID_GAIN_BLUE
>>> 5: V4L2_CID_GAIN_OFFSET
>>>
>>> I need your opinion's to get moving to add them.
>
> We already have a V4L2_CID_GAIN control and a V4L2_CID_CHROMA_GAIN control in
> the user controls class. I'd like to document how those controls and the new
> proposed gain controls interact. At first glance they don't interact at all,
> devices should not implement both, the user class gain controls are higher-
> level than the controls you proposed - this should still be documented though,
> to make sure driver and application authors will not get confused.
>
> A couple of quick questions about the new controls. Do we also need a common
> gain controls for monochrome sensors ? Is the offset always common for the 4

I think we should have a common gain control for sensors in general, 
whether monochrome or not. Many sensors support global digital gain, 
either only or besides the per-channel gains.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
