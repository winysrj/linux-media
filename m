Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51948 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0GEOs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 10:48:28 -0400
Message-ID: <4C31F0B8.4050100@infradead.org>
Date: Mon, 05 Jul 2010 11:48:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: pavan_savoy@ti.com, linux-media@vger.kernel.org,
	matti.j.aaltonen@nokia.com, pavan savoy <pavan_savoy@yahoo.co.in>,
	eduardo.valentin@nokia.com
Subject: Re: V4L2 radio drivers for TI-WL7
References: <31718.25391.qm@web94912.mail.in2.yahoo.com> <201007050821.53313.hverkuil@xs4all.nl>
In-Reply-To: <201007050821.53313.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-07-2010 03:21, Hans Verkuil escreveu:
> On Friday 02 July 2010 09:01:34 Pavan Savoy wrote:
>> Hi,
>>
>> We have/in process of developing a V4L2 driver for the FM Radio on the Texas Instruments WiLink 7 module.
>>
>> For transport/communication with the chip, we intend to use the shared transport driver currently staged in mainline at drivers/staging/ti-st/.
>>
>> To which tree should I generate patches against? is the tree
>> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>> fine ? to be used with the v4l_for_2.6.35 branch ?
> 
> You patch against git://git.linuxtv.org/v4l-dvb.git.

The latest development tree is at branch "devel/for_v2.6.36". Note, however, that
after the launch of v2.6.35, I'll create a new branch, since the merged patches
will likely get different hashes upstream. So, except if you have a short 
timeframe to develop the driver, it is better to develop it against the Linus tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Cheers,
Mauro.
