Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <makosoft@googlemail.com>) id 1JdumK-0006Kb-NZ
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 23:04:29 +0100
Received: by rv-out-0910.google.com with SMTP id b22so1901464rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 15:04:24 -0700 (PDT)
Message-ID: <c8b4dbe10803241504t68d96ec9m8a4edb7b34c1d6ef@mail.gmail.com>
Date: Mon, 24 Mar 2008 22:04:23 +0000
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "DVB ML" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] DVB-T support for original (A1C0) HVR-900
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

Hi,

I've been attempting to get something that can cleanly support DVB-T
on the original HVR-900, based on up-to-date v4l-dvb and Markus'
em2880-dvb (that is to say, something that could hopefully be cleaned
up to a mergable state and won't be too hard to keep updated if it
doesn't get merged). The current (somewhat messy, still incomplete)
tree is at http://www.makomk.com/hg/v4l-dvb-em28xx/ - em2880-dvb.c is
particularly bad. I don't have access to DVB-T signals at the moment,
but as far as I can tell, it works. Anyone want to test it? General
comments? (Other hardware will be added if I have the time,
information, and someone willing to test it.)

Thanks,
Aidan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
