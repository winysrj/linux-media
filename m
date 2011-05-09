Return-path: <mchehab@gaivota>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:36713 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1EIJxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 05:53:30 -0400
From: "Jiang, Scott" <Scott.Jiang@analog.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Date: Mon, 9 May 2011 05:53:18 -0400
Subject: RE: why is there no enum_input in v4l2_subdev_video_ops
Message-ID: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE4D@NWD2CMBX1.ad.analog.com>
References: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com>
 <Pine.LNX.4.64.1105091102320.21938@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105091102320.21938@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi all,

>> Why is there no enum_input operation in v4l2_subdev_video_ops?

> Maybe because noone needed it until now?

>> I found some drivers put this info in board specific data, but in my
>> opinion this info is sensor or decoder related.

> Can you tell which drivers / boards you're referring to?

I referred to drivers/media/video/davinci files.

>> So it should be put into the sensor drivers.

> Maybe. Also notice, I'm not a maintainer nor a principal v4l2-subdev
> developer. I've added Hans and Laurent to Cc:, will see what they say, or
> you can just point out which drivers / platforms are doing this wrong and
> propose a fix.

Sorry, I only found your mail in MAINTAINERS.

Regards,
Scott

