Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1JSqyP-0006Ds-2U
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 10:47:13 +0100
Received: from xp.homenet.telecomitalia.it (87.10.62.240) by
	relay-pt1.poste.it (7.3.122) (authenticated as Nicola.Sabbi@poste.it)
	id 47BF705F000031F1 for linux-dvb@linuxtv.org;
	Sat, 23 Feb 2008 10:47:09 +0100
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Sat, 23 Feb 2008 10:41:21 +0100
References: <47BFD5F4.3030805@shikadi.net>
In-Reply-To: <47BFD5F4.3030805@shikadi.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802231041.21591.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] Is there a daemon style program for scheduled DVB
	recording?
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

Il Saturday 23 February 2008 09:14:44 Adam Nielsen ha scritto:
> Hi everyone,
> 
> I'm currently setting up a new server that will (among other things)
> record TV shows for me.  In the past I've used cron to schedule
> recording jobs, and I've used dvbrecord to do the actual recording.
> 
> This set up has served me well for many years, but unfortunately
> dvbrecord doesn't seem to exist any more, and it never supported
> programs with AC3 audio anyway (which is pretty much all the HDTV
> channels here in Australia.)
> 
> If you were setting up a headless machine to record TV shows, what
> programs would you use to do this?  Ideally I'd like the shows dumped
> into a local directory, so that I can watch them over NFS with mplayer,
> but I'm open to alternatives.
> 
> I really want to avoid running a whole "media centre" program like
> MythTV, VDR, etc. as I'd like this to be lean and clean and I don't mind
> using the command line for playback.
> 
> Any suggestions?  I'd be happy to document the final system,
> installation, configuration, etc. on the LinuxTV wiki, as I couldn't
> find any info about this sort of thing on there at the moment.
> 
> Many thanks,
> Adam.
> 

there used to be dvbd somewhere sometimes, although I can't say how
it works because I never used it

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
