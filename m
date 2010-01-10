Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:50140 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0AJTeg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 14:34:36 -0500
Date: Sun, 10 Jan 2010 20:35:48 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_sunplus problem: more than one device is created
Message-ID: <20100110203548.23a07ce2@tele>
In-Reply-To: <4B4A0268.20104@freemail.hu>
References: <4B4A0268.20104@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 10 Jan 2010 17:38:00 +0100
Németh Márton <nm127@freemail.hu> wrote:

> I tried the gspca_sunplus driver from
> http://linuxtv.org/hg/~jfrancois/gspca/ rev 13915 on top of Linux
> kernel 2.6.32. When I plug the Trust 610 LCD PowerC@m Zoom device in
> webcam mode (0x06d6:0x0031) then two devices are created: /dev/video0
> and /dev/video1:
	[snip]

OK, this is a bug. I did not imagine that some webcams had the same
interface class for two different devices. I am fixing it.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
