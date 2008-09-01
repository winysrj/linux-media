Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1KaCQN-0005Sv-PD
	for linux-dvb@linuxtv.org; Mon, 01 Sep 2008 18:38:44 +0200
Received: by ey-out-2122.google.com with SMTP id 25so724031eya.17
	for <linux-dvb@linuxtv.org>; Mon, 01 Sep 2008 09:38:40 -0700 (PDT)
Message-ID: <a3ef07920809010938h22f71abfgb633ba9f06c2d41e@mail.gmail.com>
Date: Mon, 1 Sep 2008 09:38:40 -0700
From: "VDR User" <user.vdr@gmail.com>
To: "mailing list: linux-dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <48BB0FE7.2010109@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <200809010005.28716.liplianin@tut.by>
	<48BB0FE7.2010109@linuxtv.org>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

After some consideration, I can not ack this new api proposal.  I
believe a lot of the support for it is based in people not knowing the
current state of multiproto and thinking this might be the only path
to new needed drivers.  It hasn't helped that there has been some
misinformation spread such as the binary compatibility and so on.
There is a current pull request for multiproto right now and if done,
drivers could start being developed right now.  In the end that's what
matters to users, especially those of us who've been patiently waiting
several months or even years.

To my knowledge the multiproto api is very robust and can be easily
updated to accommodate new modulations, etc. From a technical
standpoint, I can't justify disregarding all the work thats been done
on multiproto, especially when it's finally ready to go.  In Mauro's
own response to the pull request, he admits the multiproto code is
complete.  Unless someone can provide legitimate reasons why we should
wait for yet another api to be written when multiproto is (finally)
ready to be pulled now, I'm afraid I can't support the idea.

People have been waiting to move forward with a new api for a long
time and it seems we can with multiproto right now, today.  I don't
agree that makes a very strong case of too little, too late.  Whether
it's openly admitted or not, I think we're mostly all aware that there
is some personal politics involved in this as well, which is
unfortunate.  Hopefully people will be mature enough to put that aside
and do what's best for us, the linux dvb user base, as a whole.  After
learning that multiproto is ready and there's no technical reason
against it, I wonder how many people still choose to wait for another
api to be written..?

Best regards guys!

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
