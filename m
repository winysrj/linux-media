Return-path: <mchehab@gaivota>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:27703 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1EJCoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 22:44:15 -0400
From: "Jiang, Scott" <Scott.Jiang@analog.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>
Date: Mon, 9 May 2011 22:44:05 -0400
Subject: RE: why is there no enum_input in v4l2_subdev_video_ops
Message-ID: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDFA4@NWD2CMBX1.ad.analog.com>
References: <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE0C@NWD2CMBX1.ad.analog.com>
 <Pine.LNX.4.64.1105091102320.21938@axis700.grange>
 <E43657A3F2E26048BB0EBCA7C4CB6941B4B52CDE4D@NWD2CMBX1.ad.analog.com>
 <201105092342.06166.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105092342.06166.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Laurent,

On Tue, May 10, 2011 at 5:42 AM, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> >> Why is there no enum_input operation in v4l2_subdev_video_ops?
>
> Why do you need one ?

Because I want to query decoder how many inputs it can support.
So the question is where we should store inputs info, board specific data or decoder driver?
I appreciate your advice.

>> > Maybe because noone needed it until now?
>> >
>> >> I found some drivers put this info in board specific data, but in my
>> >> opinion this info is sensor or decoder related.
>> >
>> > Can you tell which drivers / boards you're referring to?
>>
>> I referred to drivers/media/video/davinci files.
>>
>> >> So it should be put into the sensor drivers.
>> >
>> > Maybe. Also notice, I'm not a maintainer nor a principal v4l2-subdev
>> > developer. I've added Hans and Laurent to Cc:, will see what they say, or
>> > you can just point out which drivers / platforms are doing this wrong and
>> > propose a fix.
>>
>> Sorry, I only found your mail in MAINTAINERS.
>

Regards,
Scott

