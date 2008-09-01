Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <md001@gmx.de>) id 1Ka80B-0002P1-7e
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 13:55:24 +0200
To: linux-dvb@linuxtv.org
Content-Disposition: inline
From: Martin Dauskardt <md001@gmx.de>
Date: Mon, 1 Sep 2008 13:54:45 +0200
MIME-Version: 1.0
Message-Id: <200809011354.49297.md001@gmx.de>
Subject: Re: [linux-dvb] Cablestar DVB-C (Flexcop + stv0297) broken since
	changeset 7fb12d754061 (7469)
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

Am Sonntag, 24. August 2008 15:10:48 schrieb Oliver Endriss:
> Hi,
> 
> according to the thread
>   http://www.vdr-portal.de/board/thread.php?threadid=76932
> in vdr-portal, the modifications of the flexcop i2c handling in
> changeset 7fb12d754061 (7469) broke support for the Cablestar card.
> 
> Note that stv0297 does not support repeated start conditions (same
> problem as with s5h1420).
> 
> CU
> Oliver

So we have broken support for at least three cards now. (Technotrend 2400 and 
Hauppauge Noba-S-SE with s5h1420 frontend doesn`t work any longer ,too. See
http://linuxtv.org/pipermail/linux-dvb/2008-August/028249.html)

In my opinion it is not acceptable to break support for three cards in the 
v4l-dvb main tree to get one other card supported.

I strongly request to revert the changeset until a working solution for all 
cards has been tested.

Greets,
Martin

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
