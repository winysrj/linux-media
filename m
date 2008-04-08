Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1Jj9D5-0006ZQ-14
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 10:29:43 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Tue, 8 Apr 2008 10:30:04 +0200
References: <200803292240.25719.janne-dvb@grunau.be>
	<200803301353.33801.janne-dvb@grunau.be>
	<200803302017.49799.janne-dvb@grunau.be>
In-Reply-To: <200803302017.49799.janne-dvb@grunau.be>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804081030.04745.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
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

On Sunday 30 March 2008 20:17:49 Janne Grunau wrote:
> On Sunday 30 March 2008 13:53:33 Janne Grunau wrote:
> > I agree. Fixed, updated patch attached.
>
> Next try:
>
> replaced module option definition in each driver by a macro,
> fixed all checkpatch.pl error and warning
> added Signed-off-by line and patch description

ping.

Any interest in this change? Anything speaking against merging this 
except the potential duplication of udev functinality?

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
