Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:63425 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaBNBYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 20:24:39 -0500
Received: by mail-yk0-f169.google.com with SMTP id 142so21398966ykq.0
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 17:24:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140214000418.GA29848@xo-6d-61-c0.localdomain>
References: <20140213195224.GA10691@amd.pavel.ucw.cz>
	<CALzAhNVC1KRuhMks_2YUSF1e8iVEfsyvKZmphyXMqpJ+0d228Q@mail.gmail.com>
	<Pine.LNX.4.64.1402132223480.24792@axis700.grange>
	<20140214000418.GA29848@xo-6d-61-c0.localdomain>
Date: Thu, 13 Feb 2014 20:24:36 -0500
Message-ID: <CALzAhNVqiEXV3D3idj4Sgaz0_-u4HCK-yAif7AGGCT7Et9LhuQ@mail.gmail.com>
Subject: Re: Video capture in FPGA -- simple hardware to emulate?
From: Steven Toth <stoth@kernellabs.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux-Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> > Are you using a USB or PCIe controller to talk to the fpga, or does
>> > the fpga contain embedded IP cores for USB or PCIe?
>
> There should be no USB/PCIe involved.

How are you planning to connect the FPGA memory space to your host cpu
kernel memory space?

Soft CPU directly inside the fpga as a platform device?

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
