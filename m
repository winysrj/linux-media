Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48672 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbZGML1j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 07:27:39 -0400
Subject: Re: About v4l2 subdev s_config (for core) API?
From: Andy Walls <awalls@radix.net>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	v4l2_linux <linux-media@vger.kernel.org>,
	=?UTF-8?Q?=EA=B9=80=ED=98=95=EC=A4=80?= <riverful.kim@samsung.com>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?UTF-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>
In-Reply-To: <5e9665e10907130417r7e4a7bfep85c89b61981c2748@mail.gmail.com>
References: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
	 <200907112113.42883.hverkuil@xs4all.nl>
	 <5e9665e10907130119wd9d62ahaa027e49993cdc8c@mail.gmail.com>
	 <200907131047.51249.hverkuil@xs4all.nl>
	 <5e9665e10907130417r7e4a7bfep85c89b61981c2748@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 07:29:31 -0400
Message-Id: <1247484571.4067.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-07-13 at 20:17 +0900, Dongsoo, Nathaniel Kim wrote:


> Well arranged thanks to you. BTW, can you tell me about
> "s_crystal_freq" in detail? I can see that ivtv and saa7115 are using
> that but can't figure out what is exactly for. At the earlier mail, I
> considered that as a function let subdev device know about the
> frequency of clock "given" not "made by". Am I right? Please let me
> know if I'm getting wrong.
> Cheers,

As I understand it, s_crystal_freq() should be used when a different
crystal frequency could be used with a chip in differnt board designs.
For programming PLLs or dividers, the sub_device driver needs to know
what the crystal or reference frequency is.

Regards,
Andy



> Nate


