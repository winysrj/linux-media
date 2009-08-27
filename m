Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53991 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZH0VXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 17:23:01 -0400
Received: by ewy2 with SMTP id 2so1620788ewy.17
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2009 14:23:02 -0700 (PDT)
From: Eugene Yudin <eugene.yudin@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix working LifeView FlyVideo 3000 Card
Date: Fri, 28 Aug 2009 01:37:44 +0400
References: <200908280112.53765.Eugene.Yudin@gmail.com>
In-Reply-To: <200908280112.53765.Eugene.Yudin@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908280137.44350.Eugene.Yudin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

В сообщении от Пятница 28 августа 2009 01:12:53 автор Eugene Yudin написал:
> Fix this bug for this card and clones:
> > Hi, for a couple of days now, my lifeview PCI hybrid card that worked
>
> flawlessly for the last 2 years doesn't work. The problem is with the
> driver from what I understand from the logs.
>
> > Today 23/8/2009 I tried the drivers within vanilla kernel 2.6.30.5 (i386
> > and
>
> amd64) and then separately latest mercurial snapshot. I always use latest
> mercurial snapshot updating every time a new kernel is released.
>
> > This card works within Windows XP. I also switched the PCI slot but that
>
> didn't help.
>
> Now all is working great.
> Signed-off-by: Eugene Yudin <Eugene.Yudin@gmail.com>
> Best Regards, Eugene.
>
> diff -uprN a/linux/drivers/media/video/saa7134/saa7134-cards.c
> b/linux/drivers/media/video/saa7134/saa7134-cards.c
> ...
Also tuner option is processed correctly. 
It is important not to forget to specify in the "modprobe.conf":
alias char-major-81 videodev 
alias char-major-81-0 saa7134 

This is the usual line of instructions, but nevertheless not all of them 
should ...

