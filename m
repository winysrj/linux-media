Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43469 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbZIBOQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Sep 2009 10:16:26 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Wed, 2 Sep 2009 09:16:08 -0500
Subject: RE: [PATCH 0/3] image-bus API
Message-ID: <A69FA2915331DC488A831521EAE36FE40154EDD0A0@dlee06.ent.ti.com>
References: <Pine.LNX.4.64.0909021416520.6326@axis700.grange>
 <3747ed57da74762bdc7c7bda3cad06ea.squirrel@webmail.xs4all.nl>
In-Reply-To: <3747ed57da74762bdc7c7bda3cad06ea.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I haven't had time to follow through the discussion completely and to investigate if it can be used for vpfe capture. Definitely need more
time before it should be accepted.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Wednesday, September 02, 2009 9:50 AM
>To: Guennadi Liakhovetski
>Cc: Linux Media Mailing List; Paulius Zaleckas; Robert Jarzmik; Kuninori
>Morimoto; Laurent Pinchart; Karicheri, Muralidharan
>Subject: Re: [PATCH 0/3] image-bus API
>
>
>> Hi all
>>
>> Now that we definitely know on the OMAP 3 example, that a parameter like
>> "packing" is indeed needed to fully describe video on-the-bus data, I
>> haven't heard any more objections against my proposed API, so, this
>> version could well be for inclusion.
>
>A bit too optimistic I am afraid. I simply haven't had the time to look at
>this in detail :-(
>
>I fear that it won't be until the weekend of September 12th before I have
>the time to sit down and fully research this.
>
>Regards,
>
>         Hans
>
>> Of course, if there are improvement
>> suggestions, we can address them. I am CC-ing people, that took part in
>> discussing the RFC for this API (sent exactly a week ago:-)), and also
>> authors of drivers and systems that I cannot test myself. Specifically, I
>> only compile-tested the mx1_camera, and mt9m111 drivers, also would be
>> good to test on the ap325rxa SuperH platform. Notice, it looks like the
>> soc_camera_platform driver is currently broken, I am open for suggestions
>> regarding what we should do with it - deprecate and schedule for removal,
>> mark as broken, or fix:-)
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

