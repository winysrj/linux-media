Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <shaun@saintsi.co.uk>) id 1JX0ZB-0007WG-B8
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 21:50:24 +0100
From: Shaun <shaun@saintsi.co.uk>
To: linux-dvb <linux-dvb@linuxtv.org>
Date: Wed, 5 Mar 2008 20:49:37 +0000
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803052049.37038.shaun@saintsi.co.uk>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
Reply-To: shaun@saintsi.co.uk
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

Hi People,

I am writing to inform you of a simple tool I have written to help with this 
tuner issue. The tool I have made will monitor dmesg output and reset the 
MythTV Backend if it detects a mt2060 errors. It is not a fix, but a 
workaround. 

I have written it for Ubuntu/Debian based systems. I have included the GPL 
source, feel free to modify as needed.

I have it installed on a friend and my Ubuntu based boxes for the last few 
months and all seems OK.

To help with debugging issues, a log is written to:
/var/log/mythwatch.log

Example output:
[24-2-08 19:51:34] --- Started Ver: 0.2.3 ---
[27-2-08 07:33:52] ERROR: Disconnect Detected.
[27-2-08 07:33:52] ACTION: Attempting mythtv-backend restart.
[28-2-08 05:47:20] ERROR: Disconnect Detected.
[28-2-08 05:47:20] ACTION: Attempting mythtv-backend restart.
[28-2-08 16:51:28] ERROR: Disconnect Detected.
[28-2-08 16:51:28] ACTION: Attempting mythtv-backend restart.

Note: It is not perfect in that sometimes I loose a tuner without a mt2060 
error (very seldom). I am working on the idea of scanning for PAT errors in 
the MythTV backend log. There seems to be a connection with loosing a tuner 
and PAT errors.


Download URL: http://www.bluboy.f2s.com/develop/MythWatch.tar.gz

The tool allows you to record your shows at almost 100% reliability, but with 
the chance that a reset could lose a few seconds of a recording. This will 
happen if a reset happends while a show is being recorded.

Cheers
Shaun

PS: For each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software.  If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.

 
 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
