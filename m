Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:53442 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0AJUr3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 15:47:29 -0500
Message-ID: <4B4A3CDC.20400@freemail.hu>
Date: Sun, 10 Jan 2010 21:47:24 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_sunplus problem: more than one device is created
References: <4B4A0268.20104@freemail.hu> <20100110203548.23a07ce2@tele>
In-Reply-To: <20100110203548.23a07ce2@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> On Sun, 10 Jan 2010 17:38:00 +0100
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> I tried the gspca_sunplus driver from
>> http://linuxtv.org/hg/~jfrancois/gspca/ rev 13915 on top of Linux
>> kernel 2.6.32. When I plug the Trust 610 LCD PowerC@m Zoom device in
>> webcam mode (0x06d6:0x0031) then two devices are created: /dev/video0
>> and /dev/video1:
> 	[snip]
> 
> OK, this is a bug. I did not imagine that some webcams had the same
> interface class for two different devices. I am fixing it.

rev 13917 from http://linuxtv.org/hg/~jfrancois/gspca/ works correctly
with Trust 610 LCD PowerC@m Zoom device in webcam mode (0x06d6:0x0031):
only one device is created.

Thanks for the fix.

Regards,

	Márton Németh

