Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([206.112.117.35]:44554 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S934954AbZLPQUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 11:20:05 -0500
Subject: RE: USB MAssage Storage drivers
From: Philby John <pjohn@in.mvista.com>
To: Gopala Gottumukkala <ggottumu@Cernium.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
In-Reply-To: <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
References: <1259596313-16712-1-git-send-email-santiago.nunez@ridgerun.com>
	 <200912152149.33065.hverkuil@xs4all.nl>
	 <03A2FA9E0D3DC841992E682BF5287718016D39D9@lipwig.Cernium.local>
	 <1260948105.4253.21.camel@localhost.localdomain>
	 <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 21:50:07 +0530
Message-Id: <1260980407.4253.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-12-16 at 10:53 -0500, Gopala Gottumukkala wrote:
> (gcc version 3.4.3 (MontaVista 3.4.3-25.0.104.0600975 2006-07-06)) #4
> PREEMPT Tue Dec 15 18:10:24 EST 2009
> CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
> CPU: VIVT data cache, VIVT instruction cache
> Machine: DaVinci DM644x EVM
> Memory policy: ECC disabled, Data cache writeback
> DaVinci dm6446 variant 0x0
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
> 50800

And what good is this above boot log? The log that would be of interest
is the one generated the moment you connect a USB Pen drive. A
cat /proc/bus/usb/devices would also give you related information on the
connected device. Please take a look.

Regards,
Philby

