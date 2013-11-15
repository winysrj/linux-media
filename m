Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33977 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3KOTN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 14:13:56 -0500
Received: by mail-wg0-f47.google.com with SMTP id y10so3962909wgg.14
        for <linux-media@vger.kernel.org>; Fri, 15 Nov 2013 11:13:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <528671DF.7040707@iki.fi>
References: <1384103776-4788-1-git-send-email-crope@iki.fi>
	<5280D83C.5060809@xs4all.nl>
	<5280DE3D.5040408@iki.fi>
	<528671DF.7040707@iki.fi>
Date: Fri, 15 Nov 2013 14:13:55 -0500
Message-ID: <CAGoCfiz8EBqkEUuzYLXhgXGW-0S6+6s3MAFWdSpfFmuOnP+Dfg@mail.gmail.com>
Subject: Re: [PATCH RFC] libv4lconvert: SDR conversion from U8 to FLOAT
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 15, 2013 at 2:11 PM, Antti Palosaari <crope@iki.fi> wrote:
> When I do it inside Kernel, in URB completion handler at the same time when
> copying data to videobuf2, using pre-calculated LUTs and using mmap it eats
> 0.5% CPU to transfer stream to app.
>
> When I do same but using libv4lconvert as that patch, it takes ~11% CPU.

How are you measuring?  Interrupt handlers typically don't count
toward the CPU performance counters.  It's possible that the cost is
the same but you're just not seeing it in "top".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
