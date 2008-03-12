Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CKqhE6000741
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 16:52:43 -0400
Received: from smtp-out2.blueyonder.co.uk (smtp-out2.blueyonder.co.uk
	[195.188.213.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2CKq937024431
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 16:52:10 -0400
Received: from [172.23.170.145] (helo=anti-virus03-08)
	by smtp-out2.blueyonder.co.uk with smtp (Exim 4.52)
	id 1JZXvk-0004Wu-TW
	for video4linux-list@redhat.com; Wed, 12 Mar 2008 20:52:08 +0000
Received: from [82.47.98.230] (helo=[192.168.10.10])
	by asmtp-out2.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1JZXvk-0008Fq-Av
	for video4linux-list@redhat.com; Wed, 12 Mar 2008 20:52:08 +0000
Message-ID: <47D8427C.2060107@blueyonder.co.uk>
Date: Wed, 12 Mar 2008 20:52:12 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <310915.92648.qm@web31709.mail.mud.yahoo.com>
In-Reply-To: <310915.92648.qm@web31709.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Help with PCTV HD Pro Stick and openSUSE 10.3
Reply-To: sboyce@blueyonder.co.uk
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Matthew T. Gibbs wrote:
> [Sorry for top-posting this mail client isn't that great for composing]
> 
> I think I got it sorted out...I had to copy netdevice.h to the directory where it was looking for sources.  The modules were then able to build.  I had to reboot to get them to work, otherwise I got some symbol mismatch error or something like that when the modules tried to load.  After rebooting the modules seem to load properly and I can watch analog TV.  I still have to figure out how to use the digital part as Kaffeine doesn't seem to be working and Xine only seems to get one station.  Will there be a tvtime for dvb any time soon?  I hope so.  Anyway, thank you to the devs who have even gotten it this far.
> 
> Matt
> 
> ----- Original Message ----
> From: Matthew T. Gibbs <mtgibbs@yahoo.com>
> To: video4linux-list@redhat.com
> Sent: Tuesday, March 11, 2008 9:43:17 PM
> Subject: Help with PCTV HD Pro Stick and openSUSE 10.3
> 
> Hello all-
> 
> I tried to install my PCTV stick and I am getting an error that says "failed to open frontend" when I try to run dvbscan.  I tried to follow this howto
> 
> <http://mcentral.de/wiki/index.php5/Em2880>
> 
> but I couldn't get the modules to compile.  I apparently have the right module, and the stick is recognised when I plug it in.  Where do I go from here?  I tried searching but I couldn't find any related information.
> 
> Thank you,
> 
> Matt
> 
> --

A reboot was probably unneeded. After a new module is installed, "depmod 
-ae" needs to be run if it's not part of "make install".
The xine-lib that is part of openSUSE is missing stuff deemed to be 
patent encumbered, you either have to install the version from packman 
or build your own from source.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
