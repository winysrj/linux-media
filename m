Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36839 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbbEYMdx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 08:33:53 -0400
Received: by qkx62 with SMTP id 62so63134636qkx.3
        for <linux-media@vger.kernel.org>; Mon, 25 May 2015 05:33:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2b345f147f4d4bdbaf2ac15e1a78aff0@openmailbox.org>
References: <2b345f147f4d4bdbaf2ac15e1a78aff0@openmailbox.org>
Date: Mon, 25 May 2015 08:33:52 -0400
Message-ID: <CALzAhNU96djyb9eS1mtsZu2a3AvRT06RvVH9g8_i2CNp2P_2OA@mail.gmail.com>
Subject: Re: Access to MPEG-TS?
From: Steven Toth <stoth@kernellabs.com>
To: tomsmith7899@openmailbox.org
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 24, 2015 at 7:25 PM,  <tomsmith7899@openmailbox.org> wrote:
> Hello,
>
> I'm working on an application that - among other things - should be able to
> identify the programs in a MPEG transport stream broadcasted via DVB-C. This
> is what I have figured out so far:
>
> 1. Open the DVB frontend.
> 2. Fill struct dvb_frontend_parameters with transponder frequency etc.
> 3. Apply struct dvb_frontend_parameters with FE_SET_FRONTEND ioctl call.
>
> After performing these steps, I call the FE_READ_STATUS ioctl and the status
> is FE_HAS_LOCK.
>
> I should then parse the MPEG transport stream to identify the programs, pids
> etc. but my problem is that I don't know how to access the transport stream?
> I have tried to read the file descriptor returned from opening the frontend,
> but no MPEG data is found there.
>
> Can anyone point me in the right direction?

Open and configure the demux device, configure it for pid 0x2000 and
read from it once your frontend indicates you have signal lock.

Also, for your parsing needs, I suggest you don't re-invent the wheel.
Take a look at libdvbpsi.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
