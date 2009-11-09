Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48915 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZKIEre (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 23:47:34 -0500
Received: by bwz27 with SMTP id 27so3062051bwz.21
        for <linux-media@vger.kernel.org>; Sun, 08 Nov 2009 20:47:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd9524450911082035j7fa14b75q2b9edcdb1b1e85c3@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	 <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
	 <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
	 <829197380911081834v445d36c1yd931c5af69a21505@mail.gmail.com>
	 <cd9524450911081958v57b77d27iae3ab37ffef1ee8d@mail.gmail.com>
	 <829197380911082006s5a575789rd1e2881e874177cd@mail.gmail.com>
	 <cd9524450911082035j7fa14b75q2b9edcdb1b1e85c3@mail.gmail.com>
Date: Sun, 8 Nov 2009 23:47:39 -0500
Message-ID: <829197380911082047i5111615eo9e900290455b81dd@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Barry Williams <bazzawill@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 8, 2009 at 11:35 PM, Barry Williams <bazzawill@gmail.com> wrote:
> Devin
> Attached is the output from dmesg, I hope you're right
> Thanks
> Barry

Ah, based on the dmesg I can see it wasn't what I thought it was (I
saw it was dib7000 and improperly assumed it had an xc3028 tuner like
the rev1 board does).

You should probably start a new thread on the mailing list regarding
the problems you are having with this tuner.  And you will probably
need to bisect the v4l-dvb tree and see when the breakage was
introduced.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
