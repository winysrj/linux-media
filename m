Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1201 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbZCDIMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 03:12:37 -0500
Message-ID: <39946.62.70.2.252.1236154354.squirrel@webmail.xs4all.nl>
Date: Wed, 4 Mar 2009 09:12:34 +0100 (CET)
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>
Cc: "DongSoo Kim" <dongsoo.kim@gmail.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Ailus Sakari" <sakari.ailus@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wednesday 04 March 2009 09:39:48 ext Hans Verkuil wrote:
>> BTW, do I understand correctly that e.g. lens drivers also get their
>> own /dev/videoX node? Please tell me I'm mistaken! Since that would be
>> so
>> very wrong.
>
> You're mistaken :)
>
> With the v4l2-int-interface/omap34xxcam camera driver one device
> node consists of all slaves (sensor, lens, flash, ...) making up
> the complete camera device.

Phew! That's a relief. I got scared there for a moment :-)

Regards,

         Hans

>> I hope that the conversion to v4l2_subdev will take place soon. You are
>> basically stuck in a technological dead-end :-(
>
> Ok :(
>
> - Tuukka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

