Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:51785 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab0AKSHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 13:07:52 -0500
Message-ID: <4B4B68F2.4030003@freemail.hu>
Date: Mon, 11 Jan 2010 19:07:46 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: =?UTF-8?B?U3TDqXBoYW5lIE1hcmd1ZXQ=?= <smarguet@gmail.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_pac7302: sporatdic problem when plugging the device
References: <4B4A0752.6030306@freemail.hu> <20100110204844.770f8fd7@tele> <4B4A386D.3080106@freemail.hu> <20100111091030.298cedd7@tele>
In-Reply-To: <20100111091030.298cedd7@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine írta:
> Sorry, I forgot to attach the patch.
> 
>> In some usbsnoop files I have, the index 0x48 is not loaded. May you
>> try the attached patch (skip the index 0x48 and remove the delay).

100 plug-ins out of 100 OK, no errors: I say go for this patch.

I applied the patch on top of rev 14000:bc5737e0e757 from
http://linuxtv.org/hg/~jfrancois/gspca/ . I tested the driver on
top of 2.6.32 with Labtec Webcam 2200 (0x093a:0x2626).

Tested-by: Márton Németh <nm127@freemail.hu>

Thanks for the fix.

Regards,

	Márton Németh
