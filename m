Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <koos@kzdoos.xs4all.nl>) id 1NtLL6-0004rC-W5
	for linux-dvb@linuxtv.org; Sun, 21 Mar 2010 14:37:14 +0100
Received: from koos.idefix.net ([82.95.196.202] helo=kzdoos.xs4all.nl)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1NtLL6-0004ol-9e; Sun, 21 Mar 2010 14:37:12 +0100
Received: from kzdoos.xs4all.nl (localhost [127.0.0.1])
	by kzdoos.xs4all.nl (8.14.2/8.14.2/Debian-2build1) with ESMTP id
	o2LDb9Xs010797
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Sun, 21 Mar 2010 14:37:09 +0100
Received: (from koos@localhost)
	by kzdoos.xs4all.nl (8.14.2/8.14.2/Submit) id o2LDb86B010796
	for linux-dvb@linuxtv.org; Sun, 21 Mar 2010 14:37:08 +0100
Date: Sun, 21 Mar 2010 14:37:08 +0100
From: Koos van den Hout <koos@kzdoos.xs4all.nl>
To: linux-dvb@linuxtv.org
Message-ID: <20100321133708.GA9353@kzdoos.xs4all.nl>
References: <mailman.1.1269169202.10776.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <mailman.1.1269169202.10776.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Problem with decrypting dvb-s channels
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


> I have tried several players. MythTV, MPlayer, Kaffeine. All of them
> shows unencrypted channels OK, but will not play any of the encrypted
> channels.
> 
> This was working fine a couple of months back with the same HW.

"A couple of months" triggers me: for as far as I am aware dvb decoder
cards need regular 'entitlement messages' to continue to work. And
when the card is not in an active system for a long time it misses those
messages and gets shut out. You need to ask the card issuer to re-activate
the card (usually they offer this option on a website) and have the dvb-s
card, cam and dish all powered up and tuned to a transponder controlled
by the card-issuer.  Usually they advise you to tune to a certain channel.

                                            Koos

-- 
The Virtual Bookcase, the site about books, book   | Koos van den Hout
news and reviews http://www.virtualbookcase.com/   | http://idefix.net/
PGP keyid DSS/1024 0xF0D7C263                      |

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
