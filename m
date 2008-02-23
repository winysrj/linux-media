Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett1@onetel.com>) id 1JSvg0-0004Jk-S9
	for linux-dvb@linuxtv.org; Sat, 23 Feb 2008 15:48:32 +0100
Message-Id: <4D6DC025-377C-4345-9EC2-0774C4CD8007@onetel.com>
From: Tim Hewett <tghewett1@onetel.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 23 Feb 2008 14:45:51 +0000
Cc: Tim Hewett <tghewett1@onetel.com>
Subject: [linux-dvb] Is there a daemon style program for scheduled DVB
	recording?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0356861443=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0356861443==
Content-Type: multipart/alternative; boundary=Apple-Mail-48--15031523


--Apple-Mail-48--15031523
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

I just use dvbstream, scheduled using cron. To work with that I wrote  
a utility to work out which is the next schedule in the crontab and  
set the hardware alarm clock time to have the computer boot a few  
minutes in advance of the recording time, run it just before shutting  
down (it shuts it down for you) and the PC then wakes at the right  
time. I also modified dvbstream to allow the DVB device name to be  
used instead of its adaptor number, to cater for the devices changing  
numbers between bootups. Some initial changes were made to dvbstream  
to specify a programme name to be monitored in the now/next programme  
info, to try to cater for early programme starts or overruns, but I  
can't say that it is reliable as it hasn't been used much.

These are all private changes but I'm happy to share the source code  
if of interest.

Tim.

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
> into a local directory, so that I can watch them over NFS with  
> mplayer,
> but I'm open to alternatives.
>
> I really want to avoid running a whole "media centre" program like
> MythTV, VDR, etc. as I'd like this to be lean and clean and I don't  
> mind
> using the command line for playback.
>
> Any suggestions?  I'd be happy to document the final system,
> installation, configuration, etc. on the LinuxTV wiki, as I couldn't
> find any info about this sort of thing on there at the moment.
>
> Many thanks,
> Adam.
>

--Apple-Mail-48--15031523
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;">I =
just use dvbstream, scheduled using cron. To work with that I wrote a =
utility to work out which is the next schedule in the crontab and set =
the hardware alarm clock time to have the computer boot a few minutes in =
advance of the recording time, run it just before shutting down&nbsp;(it =
shuts it down for you)&nbsp;and the PC then wakes at the right time. I =
also modified dvbstream to allow the DVB device name to be used instead =
of its adaptor number, to cater for the devices changing numbers between =
bootups. Some initial changes were made to dvbstream to specify a =
programme name to be monitored in the now/next programme info, to try to =
cater for early programme starts or overruns, but I can't say that it is =
reliable as it hasn't been used much.</span></font></div><div><br =
class=3D"webkit-block-placeholder"></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: =
transparent;">These are all private changes but I'm happy to share the =
source code if of interest.</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div>Tim.</div><div=
><br class=3D"webkit-block-placeholder"></div><div><blockquote =
type=3D"cite" class=3D""><span class=3D"Apple-style-span" style=3D"color: =
rgb(0, 0, 0); font-family: Times; font-size: 16px; "><pre><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Hi everyone,

I'm currently setting up a new server that will (among other things)
record TV shows for me.  In the past I've used cron to schedule
recording jobs, and I've used dvbrecord to do the actual recording.

This set up has served me well for many years, but unfortunately
dvbrecord doesn't seem to exist any more, and it never supported
programs with AC3 audio anyway (which is pretty much all the HDTV
channels here in Australia.)

If you were setting up a headless machine to record TV shows, what
programs would you use to do this?  Ideally I'd like the shows dumped
into a local directory, so that I can watch them over NFS with mplayer,
but I'm open to alternatives.

I really want to avoid running a whole "media centre" program like
MythTV, VDR, etc. as I'd like this to be lean and clean and I don't mind
using the command line for playback.

Any suggestions?  I'd be happy to document the final system,
installation, configuration, etc. on the LinuxTV wiki, as I couldn't
find any info about this sort of thing on there at the moment.

Many thanks,
Adam.
</span></font></pre><div><font class=3D"Apple-style-span" =
face=3D"Monaco"><span class=3D"Apple-style-span" style=3D"white-space: =
pre;"><br =
class=3D"webkit-block-placeholder"></span></font></div></span></blockquote=
></div></body></html>=

--Apple-Mail-48--15031523--


--===============0356861443==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0356861443==--
