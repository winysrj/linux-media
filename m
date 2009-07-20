Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f198.google.com ([209.85.221.198]:57965 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZGTEev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 00:34:51 -0400
Received: by qyk36 with SMTP id 36so600182qyk.33
        for <linux-media@vger.kernel.org>; Sun, 19 Jul 2009 21:34:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248062429.4416.33.camel@moose.localdomain>
References: <1248062429.4416.33.camel@moose.localdomain>
Date: Mon, 20 Jul 2009 14:26:44 +1000
Message-ID: <ee0ad0230907192126kf917093k3a8f53c1cc973340@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge Okemo-B / Siano Mobile Digital MDTV
	Receiver and sms1xxx-nova-b-dvbt-01.fw
From: Damien Morrissey <damien@damienandlaurel.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi mate. Tried warm booting after running a windows session? It might
load the firmware for you as a first step?

On 7/20/09, Rodd Clarkson <rodd@clarkson.id.au> wrote:
> Hi All
>
> I recently acquired a Dell Studio XPS 16 laptop that comes equiped with
> a TV tuner card which I would like to get working with Linux.
>
> As a reference point, I'm using Fedora 11 and I live in Australia.
>
> Looking in dmesg, it wants to load sms1xxx-nova-b-dvbt-01.fw, but I
> don't have the file in  /lib/firmware
>
> I've searched for it on google, but apart from some kernel patches (that
> seem to help better identify the right firmware for the card) the only
> page that seems to help (and it's in German, which I don't speak) is
> this:
>
> http://www.der-schnorz.de/?p=92
>
> This page suggests renaming the sms1xxx-hcw-55xxx-dvbt-01.fw, which I've
> tried, but with which I'm not having a lot of luck.
>
> Initially in MythTV it detected the channels, but it never tuned into
> channels and now won't even detect the channels.
>
> Looking at the kernel source for Fedora 11, there's
> driver/media/dvd/siano, but again, I don't think this is actual firmware
> for the card.
>
> I guess what I'm getting to is:
>
> Is this card supported at this stage?
> Where do I get the correct firmware from?
>
> The www.siano-ms.com site seems to suggest they support Linux, but
> there's no download pages and no search which makes finding firmware
> hard.
>
>
> Rodd
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

-- 
Sent from my mobile device
