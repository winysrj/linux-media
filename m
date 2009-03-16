Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4120 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZCPL4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 07:56:18 -0400
Message-ID: <7898.62.70.2.252.1237204566.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Mar 2009 12:56:06 +0100 (CET)
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andy Walls" <awalls@radix.net>
Cc: linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Jean Delvare" <khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Sun, 2009-03-15 at 13:44 +0100, Hans Verkuil wrote:
>> Hi Mauro, Jean,
>>
>> When converting the bttv driver to v4l2_subdev I found one probing
>> conflict
>> between tvaudio and ir-kbd-i2c: address 0x96 (or 0x4b in 7-bit
>> notation).
>>
>> It turns out that this is one and the same PIC16C54 device used on the
>> ProVideo PV951 board. This chip is used for both audio input selection
>> and
>> for IR handling.
>
>
> Hans,
>
> Just a thought: have you confirmed with i2cdetect that the PIC16C54
> microcontroller code only responds at one I2C address?

I don't have this board, so I can't test it. Everything points to this
being a multifunction device responding to one i2c address. It's one of
those programmable devices, so that seems perfectly reasonably to me.

In general I'm not inclined to worry about this case. As Jean said, the
core problem is not so much the perceived lack of i2c support for such
devices, but that the IR and (to a lesser extent) tvaudio modules are
badly designed. The IR module should really become a v4l2_subdev as well,
loaded on command by the adapter driver, and v4l2_subdev should acquire
one or more ops to handle IR stuff. With that in place it is easy to move
the pic support from tvaudio and the IR module into a module of its own.

Simple and effective it solves this whole issue elegantly.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

