Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2EGjf7P030508
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 12:45:41 -0400
Received: from smtp01.cdmon.com (smtp01.cdmon.com [212.36.75.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2EGj9xJ006043
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 12:45:10 -0400
Received: from [192.168.1.152] (68.59.219.87.dynamic.jazztel.es [87.219.59.68])
	by smtp01.cdmon.com (Postfix) with ESMTP id A0A41F75E6
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 17:45:06 +0100 (CET)
From: Jordi Moles Blanco <jordi@cdmon.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Fri, 14 Mar 2008 17:45:00 +0100
Message-Id: <1205513100.6038.12.camel@jordipc>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: lifeview trio pci and getting dvb-s working
Reply-To: jordi@cdmon.com
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

hi,

first of all, i'm sorry if this has been asked like a million time, but
i've googled and read a lot for days and i can't get it working.

the thing is .... i'm an ubuntu user. I've tried with mythtv, vdr and
kaffeine, and i only get kaffeine working with dvb-t.

The one i've tried the most is vdr + xine, i've got this installed:

**********
ii  libdvdread3                                0.9.7-3ubuntu1
library for reading DVDs
ii  libxine-xvdr                               1.0.0~rc2-3
Xine input plugin for vdr-plugin-xineliboutp
ii  vdr                                        1.4.7-1
Video Disk Recorder for DVB cards
ii  vdr-dev                                    1.4.7-1
Video Disk Recorder for DVB cards
ii  vdr-plugin-epgsearch                       0.9.22-1
VDR plugin that provides extensive EPG searc
ii  vdr-plugin-osdteletext                     0.5.1-24
Teletext plugin for VDR
ii  vdr-plugin-remote                          0.3.9-4
VDR Plugin to support the built-in remote co
ii  vdr-plugin-xineliboutput                   1.0.0~rc2-3
VDR plugin for Xine based sofdevice frontend
ii  xineliboutput-sxfe                         1.0.0~rc2-3
Remote X-Server frontend for vdr-plugin-xine


**********

i usually install everything from the apt-get repositories. 

I've read about patches allowing lifeview to work, but they were very
old and this is a brand new installation, with kernel  2.6.22-14 and i
though that this may not be necessary.

so... after realising that apt-get doesn't allow me to use dvb-s, what
do you suggest?

do i have to install everything from sourcecode? do i have to apply all
those patches you talk about in this list and other forums? What's the
best application for my card? kaffeine? vdr?

Thanks.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
