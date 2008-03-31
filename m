Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.247])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eamonn.sullivan@gmail.com>) id 1JgHNP-0004Q3-3H
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 12:36:32 +0200
Received: by an-out-0708.google.com with SMTP id d18so2683239and.125
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 03:36:01 -0700 (PDT)
Message-ID: <e40e29dd0803310336k5de72824l6dd20ba5420531f@mail.gmail.com>
Date: Mon, 31 Mar 2008 11:36:01 +0100
From: "Eamonn Sullivan" <eamonn.sullivan@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <47F0B629.3030903@fastmail.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
References: <47F0B629.3030903@fastmail.co.uk>
Subject: Re: [linux-dvb] Nova-T 500 disconnects - solved?
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

2008/3/31 timufea <timufea@fastmail.co.uk>:
>
>  It's probably unwise to celebrate just yet, but...
>
>  I was running a vanilla 2.6.24.2 kernel, and was getting 2 or 3 USB
> disconnects each day. 5 days ago I upgraded to 2.6.24.4, and haven't had a
> USB disconnect since!
>
>  There is a fix in 2.6.24.4 for a USB bug that was introduced in Oct 2007 -
> see:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=commit;h=5475187c2752adcc6d789592b5f68c81c39e5a81
>
>  Hopefully this was the cause of the USB disconnects.
>
>  Some details of my setup, in case it's relevant:
>    Nova-T 500
>    v4l-dvb rev 127f67dea087 (Feb 26)
>    Vanilla 2.6.24.4 kernel
>    Slackware 11
>    IR remote control in use
>    Continual EIT scanning
>    Poor reception (MythTV reports 51-53%)
>
>  Frank

If true, this is excellent news (I have almost the exact same set up,
except that I've given up on the remote and the active EIT scanning to
reduce the disconnects). I've entered a bug report for this on
mythbuntu/ubuntu because the latest version (8.04, in beta) doesn't
seem to have this patch. The latest Ubuntu also uses the 2.6.24
kernel.

https://bugs.launchpad.net/ubuntu/+bug/209603

Can other Mythbuntu/Ubuntu users of the Nova-T 500 please comment on
that bug to help raise its visibility and/or add information?

-Eamonn

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
