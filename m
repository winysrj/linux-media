Return-path: <mchehab@pedra>
Received: from potemkin.univ-paris7.fr ([194.254.61.141]:61151 "EHLO
	potemkin.univ-paris7.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1CIOFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 09:05:12 -0500
Received: from univ-paris7.fr (cgunivp7.sigu7.jussieu.fr [81.194.16.84])
	by potemkin.univ-paris7.fr (8.14.2/8.14.2/relay2/25618) with ESMTP id p29Dlnuj015166
	for <linux-media@vger.kernel.org>; Wed, 9 Mar 2011 14:47:49 +0100 (CET)
Received: from [81.194.18.183] (account brice.dubost@paris7.jussieu.fr [81.194.18.183] verified)
  by univ-paris7.fr (CommuniGate Pro SMTP 4.2.10)
  with ESMTP-TLS id 69871120 for linux-media@vger.kernel.org; Wed, 09 Mar 2011 14:47:49 +0100
Subject: Re: [linux-dvb] Simultaneous recordings from one frontend
From: Brice Dubost <dubost@crans.org>
To: linux-media@vger.kernel.org
In-Reply-To: <DB7182D0-F83D-459A-8706-40E67D0ABD06@googlemail.com>
References: <DB7182D0-F83D-459A-8706-40E67D0ABD06@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 14:47:49 +0100
Message-ID: <1299678469.2196.4.camel@ipiq-HP-Compaq>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Le mercredi 09 mars 2011 à 14:41 +0100, Pascal Jürgens a écrit :
> Hi all,
> 
> - the RTP streaming apps (dvblast, mumudvb, dvbyell etc.) are designed
> to allow multiple listeners. The ideal solution would be something
> like an interface-local ipv6 multicast (mumudvb recommends using a TTL
> of 0 to prevent packets from exiting the machine, but that seems like
> a cludge). Sadly, I haven't gotten that to work [4].
> 

Hello

With MuMuDVB you can stream to 127.0.0.1 with different ports for each
channel

Unfortunately the stable release is pretty old so it will be better if
you use snapshots

If you have question about how to configure it do do that you can
contact me directly

> 
> [4] dvblast, for example, gives "warning: getaddrinfo error: Name or
> service not known
> error: Invalid target address for -d switch" when using [ff01::1%eth0]
> as the target address.
> Additionally, I wasn't able to consume a regular ipv4 multicast with
> two instances of mplayer - the first one worked, the second one
> couldn't access the url.


Concerning this issue I can give you a very simple program which dump
traffic from a multicast address. The sockets options are set
differently than mplayer so multiple instances can run simultaneously

Regards

-- 
Brice



