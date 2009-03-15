Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4894 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZCOMnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 08:43:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: bttv, tvaudio and ir-kbd-i2c probing conflict
Date: Sun, 15 Mar 2009 13:44:01 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151344.01730.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Jean,

When converting the bttv driver to v4l2_subdev I found one probing conflict 
between tvaudio and ir-kbd-i2c: address 0x96 (or 0x4b in 7-bit notation).

It turns out that this is one and the same PIC16C54 device used on the 
ProVideo PV951 board. This chip is used for both audio input selection and 
for IR handling.

But the tvaudio module does the audio part and the ir-kbd-i2c module does 
the IR part. I have truly no idea how this should be handled in the new 
situation. For that matter, I wonder whether it ever worked at all since my 
understanding is that once you called i2c_attach_client for a particular 
address, you cannot do that a second time. So depending on which module 
happens to register itself first, you either have working audio or working 
IR, but not both.

It might work if you use lirc, since that uses low-level i2c access 
(right?). But I can't see how it can work with ir-kbd-i2c and tvaudio at 
the same time.

Did some googling and this seems to confirm my analysis:

http://lists.zerezo.com/video4linux/msg21328.html

Ideas on a postcard, please... :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
