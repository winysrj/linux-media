Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:38448 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbZCPLeg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 07:34:36 -0400
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>
In-Reply-To: <200903151344.01730.hverkuil@xs4all.nl>
References: <200903151344.01730.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 07:35:40 -0400
Message-Id: <1237203340.3249.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-03-15 at 13:44 +0100, Hans Verkuil wrote:
> Hi Mauro, Jean,
> 
> When converting the bttv driver to v4l2_subdev I found one probing conflict 
> between tvaudio and ir-kbd-i2c: address 0x96 (or 0x4b in 7-bit notation).
> 
> It turns out that this is one and the same PIC16C54 device used on the 
> ProVideo PV951 board. This chip is used for both audio input selection and 
> for IR handling.


Hans,

Just a thought: have you confirmed with i2cdetect that the PIC16C54
microcontroller code only responds at one I2C address?

Regards,
Andy

