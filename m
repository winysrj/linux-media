Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44666 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab1FJNMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 09:12:25 -0400
Received: by ewy4 with SMTP id 4so896037ewy.19
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 06:12:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3e84c07f-83ff-4f83-9f8f-f52631259f05@email.android.com>
References: <4DF1FF06.4050502@hoogenraad.net>
	<3e84c07f-83ff-4f83-9f8f-f52631259f05@email.android.com>
Date: Fri, 10 Jun 2011 09:12:23 -0400
Message-ID: <BANLkTinE1vRVJ+j+7JiPHZqXHJ8WTFX+cg@mail.gmail.com>
Subject: Re: Media_build does not compile due to errors in cx18-driver.h,
 cx18-driver.c and dvbdev.c /rc-main.c
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 10, 2011 at 8:34 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> What are the error messages?
>
> Tejun Heo made quite a number of workqueue changes, and the cx18 driver got dragged forward with them.  So did ivtv for that matter.
>
> Just disable the cx18 driver if you don't need it for an older kernel.
>
> Regards,
> Andy

Another highly relevant piece of information to know is what kernel
Jan is running on.  It is probably from before the workqueue changes.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
