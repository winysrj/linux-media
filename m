Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48193 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1BROFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 09:05:45 -0500
Received: by bwz15 with SMTP id 15so745640bwz.19
        for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 06:05:44 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Hans Verkuil" <hansverk@cisco.com>, "Qing Xu" <qingx@marvell.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Neil Johnson" <realdealneil@gmail.com>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Uwe Taeubert" <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
References: <4D5D9B57.3090809@gmail.com>
 <201102181357.26382.laurent.pinchart@ideasonboard.com>
 <op.vq3om6es3l0zgt@mnazarewicz-glaptop>
 <201102181421.54063.laurent.pinchart@ideasonboard.com>
Date: Fri, 18 Feb 2011 15:05:42 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vq3qrrv33l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201102181421.54063.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> On Friday 18 February 2011 14:19:44 Michal Nazarewicz wrote:
>> Cache operations are always needed, aren't they?  Whatever you do, you
>> will always have to handle cache coherency (in one way or another) so
>> there's nothing we can do about it, or is there?

On Fri, 18 Feb 2011 14:21:53 +0100, Laurent Pinchart wrote:
> To achieve low latency still image capture, you need to minimize the time
> spent reconfiguring the device from viewfinder to still capture. Cache
> cleaning is always needed, but you can prequeue buffers you can clean the
> cache in advance, avoiding an extra delay when the user presses the still
> image capture button.

If there is enough time to perform those operation while preview is shown  
(ie.
several frames pare second), why would there not be enough time to perform
those operations for still image capture?

If I understand you correctly, what you are describing is a situation where
one has set of buffers for preview and a buffer for still image laying
around waiting to be used, right?

Such scheme will of course work, but I'm just suggesting to think of
a scheme where the unused buffer for still image is reused for preview
frames when preview is shown.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
