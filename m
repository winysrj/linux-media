Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1KANWZ-0005yu-Ih
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 13:14:31 +0200
Received: from webmail.xs4all.nl (dovemail1.xs4all.nl [194.109.26.3])
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id m5MBEImn010487
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 13:14:18 +0200 (CEST)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <9491.82.95.219.165.1214133258.squirrel@webmail.xs4all.nl>
Date: Sun, 22 Jun 2008 13:14:18 +0200 (CEST)
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] s2-3200 fec problem?
Reply-To: n.wagenaar@xs4all.nl
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

> -- SNIP --
>
> Can you give me the exact version or date of the revision which you are
> using?
> Just to be shure I do my tests on the same version as you
> are._______________________________________________

I used the current revision (I think it's 7725). The multiproto_plus tree
hasn't been updated for 2 months. I just did a normal pull of the current
tree and it worked beautifully with VDR.

Sometimes I do have strange lock problems. But I just switch to an other
transponder and back and the problem is gone.

BTW, since I have a Maxdata 4/1 DisEQC 2.0 switch, I enabled DISEQC and
used the following DISEQC config in diseqc.conf:

S19.2E  11700 V  9750  t v W15 [E0 10 38 F0] W15 A W15 t
S19.2E  99999 V 10600  t v W15 [E0 10 38 F1] W15 A W15 T
S19.2E  11700 H  9750  t V W15 [E0 10 38 F2] W15 A W15 t
S19.2E  99999 H 10600  t V W15 [E0 10 38 F3] W15 A W15 T

S13.0E  11700 V  9750  t v W15 [E0 10 38 F4] W15 B W15 t
S13.0E  99999 V 10600  t v W15 [E0 10 38 F5] W15 B W15 T
S13.0E  11700 H  9750  t V W15 [E0 10 38 F6] W15 B W15 t
S13.0E  99999 H 10600  t V W15 [E0 10 38 F7] W15 B W15 T


S23.5E  11700 V  9750  t v W15 [E0 10 38 F8] W15 B W15 t
S23.5E  99999 V 10600  t v W15 [E0 10 38 F9] W15 B W15 T
S23.5E  11700 H  9750  t V W15 [E0 10 38 FA] W15 B W15 t
S23.5E  99999 H 10600  t V W15 [E0 10 38 FB] W15 B W15 T


S28.2E  11700 V  9750  t v W15 [E0 10 38 FC] W15 B W15 t
S28.2E  99999 V 10600  t v W15 [E0 10 38 FD] W15 B W15 T
S28.2E  11700 H  9750  t V W15 [E0 10 38 FE] W15 B W15 t
S28.2E  99999 H 10600  t V W15 [E0 10 38 FF] W15 B W15 T
S28.5E  11700 V  9750  t v W15 [E0 10 38 FC] W15 B W15 t
S28.5E  99999 V 10600  t v W15 [E0 10 38 FD] W15 B W15 T
S28.5E  11700 H  9750  t V W15 [E0 10 38 FE] W15 B W15 t
S28.5E  99999 H 10600  t V W15 [E0 10 38 FF] W15 B W15 T

Cheers,

Niels Wagenaar


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
