Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:55563 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbZC3MMS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 08:12:18 -0400
Message-ID: <49D0B71A.5080801@emlix.com>
Date: Mon, 30 Mar 2009 14:12:10 +0200
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org
Subject: Re: [patch 5/5] saa7121 driver for s6000 data port
References: <13003.62.70.2.252.1238080086.squirrel@webmail.xs4all.nl> <49D09749.507@emlix.com> <200903301203.02327.hverkuil@xs4all.nl>
In-Reply-To: <200903301203.02327.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2009 12:03 PM, Hans Verkuil wrote:
> What exactly do you need? If there is something missing, then it should be 
> added. But my guess is that you can pass such information via the s_routing 
> callback. That's what all other drivers that use v4l2_subdev do.

The s_routing callback looks very limited. One can pass only two u32 values.

The parameters that have to be negotiated are:
- What is the on-wire video format?
- how many data lines are connected?
- synchronization using embedded SAV/EAV codes or using dedicated pins?
- polarity of sync lines?
- valid CRC and line number in digital blanking?
- what is the layout of the digital image?
- how many odd lines are there? how many even? (including blanking)
- how many horizontal pixels? (incl. blanking)
- where is the active region?
- on which pixels/lines do we start/end horizontal/vertical sync?

>> It seems the soc-camera framework is a better choice here, but to make it
>> work with the saa7121 one would first have to implement support for video
>> output.
> 
> This framework will also be converted to use v4l2_subdev for the 
> communication with i2c drivers.

So it shouldn't matter which one I chose?

> Actually, I recommend that you first look at the existing saa7127.c source.
> I don't know how many differences there are between the saa7121 and 
> saa7127, but perhaps support for the saa7121 can be added there rather than 
> introducing a new driver. Of course, that only works if the differences are 
> not too big.

The chips appear to be very similar, sharing most of the registers. However, the
aforementioned problem still exists with this driver. A driver connecting this
sub device must know beforehand that it has to send standard BT.656 video frames
with SAV/EAV codes.

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
