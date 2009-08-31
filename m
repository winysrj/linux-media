Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:58214 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZHaFzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 01:55:52 -0400
Message-ID: <4A9B65E6.5070005@freemail.hu>
Date: Mon, 31 Aug 2009 07:55:50 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/2] v4l2: modify the webcam video standard handling
References: <4A52E897.8000607@freemail.hu>	<4A910C42.5000001@freemail.hu> <20090830234114.16b90c36@pedra.chehab.org>
In-Reply-To: <20090830234114.16b90c36@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

first of all thank you for your detailed answer.

Mauro Carvalho Chehab wrote:
> Hi Németh,
> 
> Em Sun, 23 Aug 2009 11:30:42 +0200
> Németh Márton <nm127@freemail.hu> escreveu:
> 
>> From: Márton Németh <nm127@freemail.hu>
>>
>> Change the handling of the case when vdev->tvnorms == 0.
>>
> 
> This patch (together with a few others related to tvnorms and camera drivers)
> reopens an old discussion: should webcams report a tvnorm?
> 
> There's no easy answer for it since:
> 
> 1) removing support for VIDIOC_G_STD/VIDIOC_S_STD causes regressions, since
> some userspace apps stops working;
> 
> 2) It is a common scenario to use cameras connected to some capture only devices
> like several bttv boards used on surveillance systems. Those drivers report STD,
> since they are used also on TV;
> 
> 3) There are even some devices that allows cameras to be connected to one input and
> TV on another input. This is another case were the driver will report a TV std;
> 
> 4) Most webcam formats are based on ITU-T formats designed to be compatible
> with TV (formats like CIF and like 640x480 - and their multiple/sub-multiples);
> 
> 5) There are formats that weren't originated from TV on some digital webcams,
> so, for those formats, it makes no sense to report an existing std.
> 
> Once people proposed to create an special format for those cases
> (V4L2_STD_DIGITAL or something like that), but, after lots of discussions,
> no changes were done at API nor at the drivers.
> 
> While we don't have an agreement on this, I don't think we should apply a patch
> like this.

I was reading the V4L2 specification and based my patch on the specification.

Maybe the specification is wrong at that point? (see Chapter 1.7 Video Standards
at http://v4l2spec.bytesex.org/spec/x448.htm , starting with paragraph 6:
"Special rules apply to USB cameras...")

Regards,

	Márton Németh

