Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:43375 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0DXVHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 17:07:36 -0400
Date: Sat, 24 Apr 2010 23:07:31 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: c.pascoe@itee.uq.edu.au, kraxel@bytesex.org, pavel@ucw.cz
Subject: cx88-input questions
Message-ID: <20100424210731.GA10819@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been looking at converting drivers/media/video/cx88/cx88-input.c to 
use the ir-core subsystem, and I have a few questions.

As far as I understand the code, the sampling case will sample at a 4Khz 
interval and generate one bit for each sample to represent a pulse or 
space (i.e. a 250us resolution). This is done by writing a magic value 
in __cx88_ir_start:

	cx_write(MO_DDS_IO, 0xa80a80);

250us is a quite low resolution, is it possible to get the hardware to 
generate samples at a higher rate (say, 20Khz for a 50us resolution)?

Also, how does the polling mode work in the hardware? Is a complete 
scancode (or as complete as the hardware can handle at least) returned 
from the gpio read after a keypress?

-- 
David Härdeman
