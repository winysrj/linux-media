Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.aknet.ru ([78.158.192.26]:64067 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZALL0P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 06:26:15 -0500
Message-ID: <496B20C0.3090908@aknet.ru>
Date: Mon, 12 Jan 2009 13:51:44 +0300
From: Stas Sergeev <stsp@aknet.ru>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [patch] add video_nr module param to gspca
References: <4968EE9A.5040901@aknet.ru>	<20090111202504.644c2bb0@free.fr>	<496A53F2.7060103@aknet.ru> <20090112085103.0e84305a@free.fr>
In-Reply-To: <20090112085103.0e84305a@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Jean-Francois Moine wrote:
> Looking at the video drivers, I found that only half of these ones have
> this parameter. Then, I think it should be better to remove it
> everywhere!
OK, that might be a solution too. :)

> In fact, setting the video number in the right driver before plugging
> any video device is rather complicated while setting udev rules is easy
> and has to be done only once...
No, its not like that. You only add the
strings like
options gspca video_nr=1
in your /etc/modprobe.conf, and you are
done. ALSA went even further and introduced
the option "order", so that you write:
options snd order=snd-intel8x0,snd-hda-intel
for example. So, from some point of view, this
is actually easier than the udev solution
(eg. I always did that and never played with
udev :), but indeed, having two ways of doing
the same thing is usually confusing, so I am
not trying to talk you into applying my patch. :)
If there is an intention to deprecate the "video_nr"
thing, then it certainly doesn't apply.

