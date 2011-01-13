Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43469 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab1AMRHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 12:07:36 -0500
Received: by ewy5 with SMTP id 5so991514ewy.19
        for <linux-media@vger.kernel.org>; Thu, 13 Jan 2011 09:07:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110113174814.12c2ea5d@endymion.delvare>
References: <euouknkdsi5amcy6dha8ycx7.1294936482595@email.android.com>
	<20110113174814.12c2ea5d@endymion.delvare>
Date: Thu, 13 Jan 2011 12:07:34 -0500
Message-ID: <AANLkTim0Q8AxYZDCPZeV0+je6Us==yPFce3-zQ0ELh6e@mail.gmail.com>
Subject: Re: [PATCH 3/3] lirc_zilog: Remove use of deprecated struct
 i2c_adapter.id field
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jan 13, 2011 at 11:48 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Thu, 13 Jan 2011 11:34:42 -0500, Andy Walls wrote:
>> How should clock stretches by slaves be handled using i2c-algo-bit?
>
> It is already handled. But hdpvr-i2c doesn't use i2c-algo-bit. I2C
> support is done with USB commands instead. Maybe the hardware
> implementation doesn't support clock stretching by slaves. Apparently
> it doesn't support repeated start conditions either, so it wouldn't
> surprise me.

The hardware implementation does support clock stretching, or else it
wouldn't be working under Windows.  That said, it's possible that the
driver for the i2c master isn't checking the proper bits to detect the
clock stretch.  I haven't personally looked at the code for the i2c
master, so I cannot say one way or the other.

The Zilog is a pretty nasty beast, and for various reasons it is
especially problematic on the HD-PVR due to some issues I cannot
really get into on a public forum.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
