Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp102.rog.mail.re2.yahoo.com ([206.190.36.80]:31641 "HELO
	smtp102.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754762Ab0F0UAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 16:00:21 -0400
Message-ID: <4C27ADD3.7040700@rogers.com>
Date: Sun, 27 Jun 2010 16:00:19 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: matteo sisti sette <matteosistisette@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [Bulk] Re: v4l-dvb bug report
References: <AANLkTimAu1tX1Ta7CrvotfsVpV36CkJ-2nSLxZ4YgDZT@mail.gmail.com>	<AANLkTilS2e9xJASSDfDkIIxU5yNE3Z-UVaDAergM5o8K@mail.gmail.com> <AANLkTikiOGuCqMUY42YOjrABApc2y2_HcYFe2llc9q7U@mail.gmail.com>
In-Reply-To: <AANLkTikiOGuCqMUY42YOjrABApc2y2_HcYFe2llc9q7U@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

matteo sisti sette wrote:
> Yeah, thank you, I have found the FIREDTV=n trick on some other forum
> just a few minutes before I read your reply, and with that change it
> has compiled fine :)
>   
oops, I just sent my reply before I saw that you already figured it out

> I'm not sure what firedtv is but I don't think I need it :)
>   

its a driver for some firewire based DVB devices ... you won't need it.

> By the way may I ask a newbie question? If you need the kernel sources
> to compile v4l-dvb, it does not mean that you're recompiling the
> kernel, does it? :$

that's correct ... all you are doing is building the v4l-dvb drivers
against your specific kernel ...  after building them, you can then
install them, which effectively replaces the kernel supplied set of
v4l-dvb drivers with the set you just compiled/built
