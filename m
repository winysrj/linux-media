Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from server42.ukservers.net ([217.10.138.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stephen@rowles.org.uk>) id 1Jy22Z-0001O4-G9
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 11:52:24 +0200
Received: from server42.ukservers.net (localhost.localdomain [127.0.0.1])
	by server42.ukservers.net (Postfix smtp) with ESMTP id 08E4CA720B
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 10:51:49 +0100 (BST)
Received: from miner.localdomain (unknown [89.240.61.40])
	by server42.ukservers.net (Postfix smtp) with ESMTP id E0DACA71E6
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 10:51:48 +0100 (BST)
Received: from manicminer.homeip.net (miner [127.0.0.1])
	by miner.localdomain (Postfix) with ESMTP id 19C661855D
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 10:51:48 +0100 (BST)
Message-ID: <49403.81.144.130.125.1211190708.squirrel@manicminer.homeip.net>
In-Reply-To: <cc9679b791c3fa15ec83ebc10b5ba8d3@nkindia.com>
References: <cc9679b791c3fa15ec83ebc10b5ba8d3@nkindia.com>
Date: Mon, 19 May 2008 10:51:48 +0100 (BST)
From: "Stephen Rowles" <stephen@rowles.org.uk>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] EIT EPG parser
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

> Hi all,
> I am looking for EPG / EIT parser. Any who have already implemented this
> or
> can help me in some other way.
> Gurumurti
>

I have used this program to grab EPG data from DVB-T transmissions in the UK:

http://darkskiez.co.uk/index.php?page=tv_grab_dvb

It will produce xmltv format xml which can then be used with various
different programs for display.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
