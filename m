Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1KvC9k-000627-UA
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 15:36:21 +0100
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds2011.yellis.net (Postfix) with ESMTP id 67ACE2FA894
	for <linux-dvb@linuxtv.org>; Wed, 29 Oct 2008 15:36:17 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id E3DA51300139
	for <linux-dvb@linuxtv.org>; Wed, 29 Oct 2008 15:36:14 +0100 (CET)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jpvueqOvvUtd for <linux-dvb@linuxtv.org>;
	Wed, 29 Oct 2008 15:36:10 +0100 (CET)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 315B3130010E
	for <linux-dvb@linuxtv.org>; Wed, 29 Oct 2008 15:36:10 +0100 (CET)
Message-ID: <490874D9.6080708@anevia.com>
Date: Wed, 29 Oct 2008 15:36:09 +0100
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <4906E9CA.90003@anevia.com>
In-Reply-To: <4906E9CA.90003@anevia.com>
Subject: Re: [linux-dvb] cx88-blackbird mailbox timeout
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Frederic CAND a =E9crit :
> Dear all,
> I'm using one of the latest snapshots with my hauppauge hvr1300. I'm =

> encoutering an issue, where randomly the mpeg ps device does not contain =

> any sound track at all. I insist on the random side of the thing. If I =

> completly power off my computer, no card can be affected by this bug, or =

> any other card can be. But when a card is affected, it is until the =

> computer is powered off. Unloading / reloading the modules won't fix.
> =

> Other thing, on closing an mpeg device affected by this bug, the dmesg =

> will contain :
> =

> cx88[2]/2-bb: ERROR: API Mailbox timeout
> =

> then, opening the device again will show this message :
> [62153.237112] cx88[2]/2-bb: ERROR: Mailbox appears to be in use (7)
> [62155.868701] cx88[2]/2-bb: Firmware upload successful.
> [62155.872299] cx88[2]/2-bb: Firmware version is 0x02060039
> =

> Any idea ?
> =

So if anyone is interested, the cause of this issue is the following "fix" :

http://linuxtv.org/hg/v4l-dvb/rev/93e265de2a56

when reverse applying it, I got the sound track in all my mpeg devices, =

and then "api mailbox timeout" message never appeared afterwards.

I can prepare a patch if you want. Who should I send it to ?
-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
