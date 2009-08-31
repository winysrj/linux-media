Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4936 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZHaPHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 11:07:36 -0400
Message-ID: <3b674866ac8647a2fddfa9e3cee94cdb.squirrel@webmail.xs4all.nl>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40154EDC3DC@dlee06.ent.ti.com>
References: <200908291631.13696.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.0908300109490.16132@axis700.grange>
    <200908310823.29158.hverkuil@xs4all.nl>
    <A69FA2915331DC488A831521EAE36FE40154EDC3DC@dlee06.ent.ti.com>
Date: Mon, 31 Aug 2009 17:07:34 +0200
Subject: RE: RFC: bus configuration setup for sub-devices
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"Laurent Pinchart" <laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>>>
>>> Up to now I usually saw the master-slave relationship defined as per
>>> whether the protocol is "master" or "slave," which always was used from
>>> the PoV of the bridge. I.e., even in a camera datasheet a phrase like
>>> "supports master-parallel mode" means supports a mode in which the
>>> bridge
>>> is a master and the camera is a slave. So, maybe it is better instead
>>> of
>>a
>>> .is_master flag to use a .master_mode flag?
>>
>>Sounds reasonable. I'll check a few datasheets myself to see what
>>terminology
>>they use.
>
> Master/Slave is always confusing to me. In VPFE, it can act as master
> (when it output sync signal and pixel clock) and slave (when it get sync
> signal from sensor/decoder). We use VPFE as slave and sensor/decoder will
> provide the pixel clock and sync signal. Please confirm if this is what
> master_mode flag means.

That's correct: the master provides the pixel clock signal. I'm not sure
if it also means that the syncs are provided by the master. Do you know?

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

