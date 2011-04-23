Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61555 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab1DWMh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 08:37:27 -0400
Received: by wwa36 with SMTP id 36so1302717wwa.1
        for <linux-media@vger.kernel.org>; Sat, 23 Apr 2011 05:37:25 -0700 (PDT)
Message-ID: <4DB2C88D.1040200@gmail.com>
Date: Sat, 23 Apr 2011 14:39:41 +0200
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <4DB1FE58.20006@usa.net> <4DB2BA0B.20906@gmail.com> <4DB2C20E.1050701@usa.net>
In-Reply-To: <4DB2C20E.1050701@usa.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,
> Okay, but have you managed to decode any channel yet ?
>   
Yes, I managed to descramble programmes without any problem.
> I find some code odd, maybe you can take a look as well...
>
> init_channel in ngene-core.c creates the device sec0/caio0 with the
> struct ngene_dvbdev_ci. In ngene-dvb.c you can see that this struct
> declares the methods ts_read/ts_write to handle r/w operations on the
> device sec0/caio0.
>
> Now take a look at those methods (ts_read/ts_write). I don't see how
> they 'connect' to the file cxd2099.c which contains the methods handling
> the i/o to the cam
They don't connect explicitly. Transfers are done implicitly
through nGene ring-buffers. See demux_tasklet(). CXD code
seems to be used only for CAM commands and setup (only) of
data transfers.

Unfortunately, I don't have nGene (and CXD) chip
documentation, so I stopped solving the problem myself. I
don't want to write software by guessing how HW works.

Best regards,
Martin Vidovic
