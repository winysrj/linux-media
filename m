Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kie6j-0005Vm-Of
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 01:49:22 +0200
Message-ID: <48DAD1FD.1060801@linuxtv.org>
Date: Thu, 25 Sep 2008 01:49:17 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mika Laitio <lamikr@pilppa.org>
References: <Pine.LNX.4.64.0809250125040.11057@shogun.pilppa.org>
In-Reply-To: <Pine.LNX.4.64.0809250125040.11057@shogun.pilppa.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb-t fix for hvr-4000 multiproto
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

Mika Laitio wrote:
> memset and udelay changes from s2-mfe were really not making any visible
> changes for me, but at least the memset call is a good thing to do.

+	memset(&core->board, 0, sizeof(core->board));
 	memcpy(&core->board, &cx88_boards[core->boardnr], sizeof(core->board));

Contrary to your opinion, this call to memset is superflous, as all the
zeroes get overwritten by the call to memcpy.

Regards,
Andreas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
