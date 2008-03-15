Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2FIOE4I016030
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 14:24:14 -0400
Received: from smtp01.cdmon.com (smtp01.cdmon.com [212.36.75.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2FINYH1027642
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 14:23:35 -0400
From: Jordi Moles Blanco <jordi@cdmon.com>
To: hermann pitton <hermann-pitton@arcor.de>, video4linux-list@redhat.com
In-Reply-To: <1205588984.4696.17.camel@pc08.localdom.local>
References: <1205513100.6038.12.camel@jordipc>
	<1205588984.4696.17.camel@pc08.localdom.local>
Content-Type: text/plain
Date: Sat, 15 Mar 2008 19:23:27 +0100
Message-Id: <1205605407.6039.2.camel@jordipc>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: lifeview trio pci and getting dvb-s working
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

Hi,

thank you very much for all the details, it's been really helpful, i'll
try to do as you suggest.

thanks.


El ds 15 de 03 del 2008 a les 14:49 +0100, en/na hermann pitton va
escriure:
> Hi,
> 
> Am Freitag, den 14.03.2008, 17:45 +0100 schrieb Jordi Moles Blanco:
> > hi,
> > 
> > first of all, i'm sorry if this has been asked like a million time, but
> > i've googled and read a lot for days and i can't get it working.
> 
> no problem, you are only the second asking this within the last years.
> 
> > the thing is .... i'm an ubuntu user. I've tried with mythtv, vdr and
> > kaffeine, and i only get kaffeine working with dvb-t.
> > 
> > The one i've tried the most is vdr + xine, i've got this installed:
> > 
> > **********
> > ii  libdvdread3                                0.9.7-3ubuntu1
> > library for reading DVDs
> > ii  libxine-xvdr                               1.0.0~rc2-3
> > Xine input plugin for vdr-plugin-xineliboutp
> > ii  vdr                                        1.4.7-1
> > Video Disk Recorder for DVB cards
> > ii  vdr-dev                                    1.4.7-1
> > Video Disk Recorder for DVB cards
> > ii  vdr-plugin-epgsearch                       0.9.22-1
> > VDR plugin that provides extensive EPG searc
> > ii  vdr-plugin-osdteletext                     0.5.1-24
> > Teletext plugin for VDR
> > ii  vdr-plugin-remote                          0.3.9-4
> > VDR Plugin to support the built-in remote co
> > ii  vdr-plugin-xineliboutput                   1.0.0~rc2-3
> > VDR plugin for Xine based sofdevice frontend
> > ii  xineliboutput-sxfe                         1.0.0~rc2-3
> > Remote X-Server frontend for vdr-plugin-xine
> > 
> > 
> > **********
> > 
> > i usually install everything from the apt-get repositories. 
> > 
> > I've read about patches allowing lifeview to work, but they were very
> > old and this is a brand new installation, with kernel  2.6.22-14 and i
> > though that this may not be necessary.
> > 
> > so... after realising that apt-get doesn't allow me to use dvb-s, what
> > do you suggest?
> > 
> > do i have to install everything from sourcecode? do i have to apply all
> > those patches you talk about in this list and other forums? What's the
> > best application for my card? kaffeine? vdr?
> > 
> > Thanks.
> > 
> 
> You need either the current v4l-dvb master repo or Hartmut Hackmann's
> v4l-dvb repo installed. A current 2.6.25-rc should work as well.
> 
> After "make" take care with "make rmmod" and "make rminstall", that
> really all old media modules are removed, before doing "make install".
> 
> You need to load saa7134-dvb with "use_frontend=1" or better put
> "options saa7134-dvb use_frontend=1 debug=3" in /etc/modprobe.conf or on
> Ubuntu it should be modprobe.d and "depmod -a".
> 
> After "modprobe saa7134" you should see that a DVB-S frontend is
> attached.
> 
> Then start kaffeine, it will pick up the frontend and you select in DVB
> settings your LNB type and the satellite to use. You should then be able
> to start a channel scan. For more complex sat systems with switches and
> rotors and advanced diseqc we have no test reports yet.
> 
> Good Luck,
> Hermann
> 
> 
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
