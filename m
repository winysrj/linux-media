Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f216.google.com ([209.85.220.216]:54965 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZISBHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 21:07:17 -0400
Received: by fxm12 with SMTP id 12so1139780fxm.18
        for <linux-media@vger.kernel.org>; Fri, 18 Sep 2009 18:07:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AB39EF2.3020807@sipradius.com>
References: <4AB39EF2.3020807@sipradius.com>
Date: Sat, 19 Sep 2009 05:29:46 +0430
Message-ID: <d2f7e03e0909181759qf552c86x6fd0cdc818f829b@mail.gmail.com>
Subject: Re: [linux-dvb] choice between MPE and ULE in the code
From: Seyyed Mohammad mohammadzadeh <softnhard.es@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have tried the ULE decapsulation part of code. you can find it in
the v4l_dvb/linux/driver/media/dvb_core/dvb_net.c you must force ULE
decapsulation in the code and there is no media to choose it run-time.
The decapsulation code is too bogus and useless. I'm trying to write a
new decapsulator based on the original code.

2009/9/18, Sylvain LESAGE <sylvain@sipradius.com>:
> Hi,
>
> I am working on ULE (ultra-lightweight encapsulation) and MPE
> (multi-protocol encapsulation) decapsulation of transport stream
> packets. I can't find, in the code of linuxDVB, where the choice is done
> between ULE or MPE when parsing the packets ?
> Does someone has an idea ?
>
> Thank you.
> Sylvain LESAGE
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
