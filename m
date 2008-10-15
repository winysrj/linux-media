Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1Kq7IE-0000fY-HG
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 16:24:08 +0200
Received: by nf-out-0910.google.com with SMTP id g13so1307096nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 15 Oct 2008 07:24:02 -0700 (PDT)
Message-ID: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
Date: Wed, 15 Oct 2008 10:24:02 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Revisiting the SNR/Strength issue
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

I know that this has been brought up before, but would it be possible
to revisit the issue with SNR and strength units of measure being
inconsistent across frontends?

I know that we don't always know what the units of measure are for
some frontends, but perhaps we could at least find a way to tell
applications what the units are for those frontends where it is known?

For example, if we had a call that returned the units that the
frontend is expecting to return the SNR in (e.g. dB, %, etc),
applications would know how to handle it (and for those cases where we
really don't know what the units are, the call can return "unknown" so
the application just represents the value on a linear scale).

I know we probably can't agree on what units the SNR field should
return, but if we could at least agree on a way where the frontend can
tell us what the units are, the field could actually be useful to
applications.  This approach would be backward compatible because we
wouldn't be expecting any of the frontends to change how they return
the underlying data - it would only have to add an additional call
implemented to return what units that data is in.

Right now the fields are pretty useless to applications.  For example,
with Kaffeine the data shows up great with my HVR-950 (which returns a
percentage), but when it said 0% with my Pinnacle 801e, as a user I
thought something was broken (the s5h1411 returns data in dB).

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
