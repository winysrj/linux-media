Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:34068 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbbFOSfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 14:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <20150612064109.GT5904@valkosipuli.retiisi.org.uk>
References: <1433971645-32304-1-git-send-email-sakari.ailus@iki.fi>
 <1434050281-27861-1-git-send-email-sakari.ailus@iki.fi> <4041793.jETg7P3oYY@avalon>
 <20150612064109.GT5904@valkosipuli.retiisi.org.uk>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 15 Jun 2015 11:34:52 -0700
Message-ID: <CAK5ve-+VNJA48KbA=pmeMYVvm0Wh3FBmW5m6JnodtrLYEEF7fw@mail.gmail.com>
Subject: Re: [PATCH v1.3 1/5] v4l: async: Add a pointer to of_node to struct
 v4l2_subdev, match it
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux LED Subsystem <linux-leds@vger.kernel.org>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	mchehab@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 11, 2015 at 11:41 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Thu, Jun 11, 2015 at 10:27:30PM +0300, Laurent Pinchart wrote:
>> Hi Sakari,
>>
>> Thank you for the patch.
>>
>> On Thursday 11 June 2015 22:18:01 Sakari Ailus wrote:
>> > V4L2 async sub-devices are currently matched (OF case) based on the struct
>> > device_node pointer in struct device. LED devices may have more than one
>> > LED, and in that case the OF node to match is not directly the device's
>> > node, but a LED's node.
>> >
>> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Bryan, could you apply the patch to your tree? It's required by Jacek's
> patchset you attempted to apply a few days back.
>
> Thanks!

Sure, I will merge that through my tree.

Thanks,
-Bryan
