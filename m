Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2e.orange.fr ([80.12.242.112]:10084 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab0AUNUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 08:20:46 -0500
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Dump Complete DVB Stream, How to Dump Complete DVB Stream
Date: Thu, 21 Jan 2010 14:20:08 +0100
References: <fd9871421001210357i2f515829m2aad024173967b6a@mail.gmail.com>
In-Reply-To: <fd9871421001210357i2f515829m2aad024173967b6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001211420.08757.hftom@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 21 janvier 2010 12:57:00, dvbfreaky 007 a écrit :
> Hi ,
> Can any one suggest me on linux, How to capture/dump/Save complete DVB
> Stream( Not elementary Streams).
> 
> To capture elementary stream, I know these
> 1. dvbstream -f xxxxxx -o pid > /home/user/111/ts

-o 8192

> 2. Through VLC also can able to store ( But i am not succeeding all times)
> 3. Dumpstream option in mplayer
> 
> 
> 
> Is there any application to stream out (via RTP) complete DVB TS throughout
> LAN??
> Note: Not elementary Stream Out ( VLC does only Elementary Stream Out)
> Can Any one help in this regard?
> 
> please throw your pointers.
> 
> Thanks in Advance,
> Santhosh Kumar B
> 

-- 
Christophe Thommeret


