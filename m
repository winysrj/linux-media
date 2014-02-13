Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:39109 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaBMUcP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 15:32:15 -0500
Received: by mail-yh0-f41.google.com with SMTP id f73so10839821yha.0
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 12:32:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140213195224.GA10691@amd.pavel.ucw.cz>
References: <20140213195224.GA10691@amd.pavel.ucw.cz>
Date: Thu, 13 Feb 2014 15:32:14 -0500
Message-ID: <CALzAhNVC1KRuhMks_2YUSF1e8iVEfsyvKZmphyXMqpJ+0d228Q@mail.gmail.com>
Subject: Re: Video capture in FPGA -- simple hardware to emulate?
From: Steven Toth <stoth@kernellabs.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 13, 2014 at 2:52 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> I'm working on project that will need doing video capture from
> FPGA. That means I can define interface between kernel and hardware.
>
> Is there suitable, simple hardware we should emulate in the FPGA? I
> took a look, and pxa_camera seems to be one of the simple ones...

Thats actually a pretty open-ended question. You might get better
advice if you describe your hardware platform in a little more detail.

Are you using a USB or PCIe controller to talk to the fpga, or does
the fpga contain embedded IP cores for USB or PCIe?

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
