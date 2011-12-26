Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:60519 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1LZTeF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 14:34:05 -0500
Received: from webmail.schinagl.nl (localhost [127.0.0.1])
	by 7of9.schinagl.nl (Postfix) with ESMTPA id 1848122E1B
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:34:45 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Dec 2011 21:34:44 +0200
From: Oliver Schinagl <oliver@schinagl.nl>
To: <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] saa7146 based TT1500 dvb-t doesn't find channels
In-Reply-To: <4EF8BF82.2050609@schinagl.nl>
References: <4EF8BF82.2050609@schinagl.nl>
Message-ID: <cfa78a6d4073b327fbd4c5576cf94751@webmail.schinagl.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replying to my own message, I've found something to dig into further.

546000: (time: 00:43) (time: 00:45) signal ok:
         QAM_AUTO f = 546000 kHz I999B8C999D999T999G999Y0
Info: NIT(actual) filter timeout
554000: (time: 00:59) (time: 01:00) signal ok:
         QAM_AUTO f = 554000 kHz I999B8C999D999T999G999Y0
Info: NIT(actual) filter timeout
562000: (time: 01:15)
570000: (time: 01:18) (time: 01:19) signal ok:
         QAM_AUTO f = 570000 kHz I999B8C999D999T999G999Y0
Info: NIT(actual) filter timeout


Those frequenties that the signal is ok on, is what our dvb-t signal is 
transmitted on. Still don't understand why it does work under gentoo, 
but not under mythbuntu :S

On 26.12.2011 20:40, Oliver Schinagl wrote:
> Hi!
>
> I'm using a TT1500-dvbt card, using the saa7146 budget_ci driver. On
> my tv-pc I have 2 partitions with gentoo and latest mythbuntu. Under
> gentoo everything works-ish. Under mythbuntu however, I cannot get it
> to find any channels using scan, dvbscan or w_scan. I copied the
> firmware for the tda10046h from the gentoo partition, thinking that
> may make the difference, but but even though binary different, they
> both report revision 29 (and it still doesn't work). w_scan does
> mention my tuner etc and even says 'signal ok' on certain 
> frequencies,
> but eventually ends with 0 services found. I'm dumbfounded at to why 
> I
> cannot get it to work, when the only difference is the OS.
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead 
> linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

