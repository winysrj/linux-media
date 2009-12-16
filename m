Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([206.112.117.35]:10316 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S934942AbZLPQSl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 11:18:41 -0500
Message-ID: <4B2908B9.8030509@ru.mvista.com>
Date: Wed, 16 Dec 2009 19:20:09 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
To: Gopala Gottumukkala <ggottumu@Cernium.com>
Cc: Philby John <pjohn@in.mvista.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
Subject: Re: USB MAssage Storage drivers
References: <1259596313-16712-1-git-send-email-santiago.nunez@ridgerun.com>	<200912152149.33065.hverkuil@xs4all.nl>	<03A2FA9E0D3DC841992E682BF5287718016D39D9@lipwig.Cernium.local>	<1260948105.4253.21.camel@localhost.localdomain> <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
In-Reply-To: <03A2FA9E0D3DC841992E682BF5287718016D3A53@lipwig.Cernium.local>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

Gopala Gottumukkala wrote:

> (gcc version 3.4.3 (MontaVista 3.4.3-25.0.104.0600975 2006-07-06)) #4
> PREEMPT Tue Dec 15 18:10:24 EST 2009
> CPU: ARM926EJ-S [41069265] revision 5 (ARMv5TEJ), cr=00053177
> CPU: VIVT data cache, VIVT instruction cache
> Machine: DaVinci DM644x EVM
> Memory policy: ECC disabled, Data cache writeback
> DaVinci dm6446 variant 0x0
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
> 50800

> I have compile the kernel 2.6.32 and boot up the target.  But when I
> plug in the mass storage like external HDD or Pendrive it is not
> recognizing.

> Any help appreciated.

    Try this patch:

http://marc.info/?l=linux-usb&m=126087668419996

WBR, Sergei
