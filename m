Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34740 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZHaPMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 11:12:43 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Date: Mon, 31 Aug 2009 10:12:31 -0500
Subject: RE: RFC: bus configuration setup for sub-devices
Message-ID: <A69FA2915331DC488A831521EAE36FE40154EDC439@dlee06.ent.ti.com>
References: <200908291631.13696.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.0908300109490.16132@axis700.grange>
    <200908310823.29158.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE40154EDC3DC@dlee06.ent.ti.com>
 <3b674866ac8647a2fddfa9e3cee94cdb.squirrel@webmail.xs4all.nl>
In-Reply-To: <3b674866ac8647a2fddfa9e3cee94cdb.squirrel@webmail.xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>>
>> Master/Slave is always confusing to me. In VPFE, it can act as master
>> (when it output sync signal and pixel clock) and slave (when it get sync
>> signal from sensor/decoder). We use VPFE as slave and sensor/decoder will
>> provide the pixel clock and sync signal. Please confirm if this is what
>> master_mode flag means.
>
>That's correct: the master provides the pixel clock signal. I'm not sure
>if it also means that the syncs are provided by the master. Do you know?
Yes. Both hsync and vsync signals can be output from VPFE. So also field id signal. But I don't know if any customer is using it that way.
>
>Regards,
>
>         Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

