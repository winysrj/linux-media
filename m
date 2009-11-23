Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:51299 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbZKWS1P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 13:27:15 -0500
Message-ID: <4B0AD3F8.2010606@freemail.hu>
Date: Mon, 23 Nov 2009 19:27:04 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: =?UTF-8?B?R3VzdGF2byBDaGHDrW4gRHVtaXQ=?= <g@0xff.cl>
CC: Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: VFlip problem in gspca_pac7311
References: <20091123141042.47feac9e@0xff.cl>
In-Reply-To: <20091123141042.47feac9e@0xff.cl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Gustavo Chaín Dumit wrote:
> Hi
> 
> I'm testing a Pixart Imaging device (0x93a:0x2622)
> Everything works fine, but vertical orientation. Image looks rotated.
> So I wrote a little hack to prevent it.
> [...]
> Any one has the same problem ?

You might want to have a look to libv4l ( http://freshmeat.net/projects/libv4l )
and the v4lcontrol_flags[] in
http://linuxtv.org/hg/v4l-dvb/file/2f87f537fb2b/v4l2-apps/libv4l/libv4lconvert/control/libv4lcontrol.c .
This user space library has a list of laptops where the webcams are installed
for example upside down.

Regards,

	Márton Németh
