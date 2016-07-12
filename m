Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:24486 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbcGLRPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 13:15:00 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/2] media: platform: transfer format translations to soc_mediabus
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
	<1459607213-15774-2-git-send-email-robert.jarzmik@free.fr>
	<703509de-bc2a-0d4b-7ae7-a0c0efd98e41@xs4all.nl>
Date: Tue, 12 Jul 2016 19:14:51 +0200
In-Reply-To: <703509de-bc2a-0d4b-7ae7-a0c0efd98e41@xs4all.nl> (Hans Verkuil's
	message of "Mon, 4 Jul 2016 11:23:15 +0200")
Message-ID: <87r3ay3his.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 04/02/2016 04:26 PM, Robert Jarzmik wrote:
>> Transfer the formats translations to soc_mediabus. Even is soc_camera
>> was to be deprecated, soc_mediabus will survive, and should describe all
>> that happens on the bus connecting the image processing unit of the SoC
>> and the sensor.
>> 
>> The translation engine provides an easy way to compute the formats
>> available in the v4l2 device, given any sensors format capabilities
>> bound with known image processing transformations.
>
> I prefer that you just make a copy of this for use in the pxa driver.
>
> We might make this (or a variant) available for all drivers in the future,
> but for now just split off the pxa driver without introducing new media
> includes.
Okay, as you wish.

Cheers.

--
Robert
