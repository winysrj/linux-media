Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:41494 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbZFZNtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 09:49:25 -0400
Received: by gxk26 with SMTP id 26so808086gxk.13
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 06:49:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246017001.4755.4.camel@palomino.walls.org>
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>
	 <1246017001.4755.4.camel@palomino.walls.org>
Date: Fri, 26 Jun 2009 09:42:06 -0400
Message-ID: <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>
Subject: Re: Bah! How do I change channels?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: George Adams <g_adams27@hotmail.com>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 26, 2009 at 7:50 AM, Andy Walls<awalls@radix.net> wrote:
> I use either v4l2-ctl or ivtv-tune
>
> $ ivtv-tune -d /dev/video0 -t us-bcast -c 3
> /dev/video0: 61.250 MHz
>
> $ v4l2-ctl -d /dev/video0 -f 61.250
> Frequency set to 980 (61.250000 MHz)
>
>
> Regards,
> Andy

Hello Andy,

I had sent George some email off-list with basically the same
commands.  I think what might be happening here is the tuner gets
powered down when not in use, so I think it might be powered down
between the v4l-ctl command and the running of the other application.

I have sent him a series of commands to try where he modprobes the
xc3028 driver with "no_poweroff=1", and we will see if that starts
working.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
