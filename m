Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24580 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbZFOIps (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 04:45:48 -0400
Message-ID: <4A360A28.8080008@maxwell.research.nokia.com>
Date: Mon, 15 Jun 2009 11:45:28 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: hvaibhav@ti.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Brijesh Jadav <brijesh.j@ti.com>,
	Hardik Shah <hardik.shah@ti.com>
Subject: Re: tcm825x.c: migrating to sub-device framework?
References: <hvaibhav@ti.com> <200906141214.38355.hverkuil@xs4all.nl> <200906141444.54105.hverkuil@xs4all.nl> <200906141632.21098.hverkuil@xs4all.nl>
In-Reply-To: <200906141632.21098.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 14 June 2009 14:44:53 Hans Verkuil wrote:
>> On Sunday 14 June 2009 12:14:38 Hans Verkuil wrote:
>>> On Wednesday 06 May 2009 20:31:33 hvaibhav@ti.com wrote:
>>>> From: Vaibhav Hiremath <hvaibhav@ti.com>
>>>>
>>>> This patch converts TVP514x driver to sub-device framework
>>>> from V4L2-int framework.
> 
> Now that tvp514x is converted to using v4l2_subdev (pending a few small final
> tweaks) there is only one driver left that uses the v4l2-int-device.h API:
> tcm825x.c.

There's also the OMAP 2 camera driver (master), 
drivers/media/video/omap24xxcam.c. The tcm825x is the slave driver that 
is used in conjunction with omap24xxcam on N800 and N810.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
