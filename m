Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4B0XVPC014075
	for <video4linux-list@redhat.com>; Sun, 10 May 2009 20:33:31 -0400
Received: from smtp130.rog.mail.re2.yahoo.com (smtp130.rog.mail.re2.yahoo.com
	[206.190.53.35])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n4B0XHID021038
	for <video4linux-list@redhat.com>; Sun, 10 May 2009 20:33:17 -0400
Message-ID: <4A077247.8030305@rogers.com>
Date: Sun, 10 May 2009 20:33:11 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: William Case <billlinux@rogers.com>
References: <1241982336.31677.0.camel@localhost.localdomain>
In-Reply-To: <1241982336.31677.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: Hauppauge WinTV-hvr-1800 PCIe won't work with tvtime or mplayer.
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

William Case wrote:
> Hi;
>
> I have been trying to get my tuner card working for over a week now.
>
> I have tried all the advice I can find on various sites as well as the
> Fedora users list.  But no joy.  It was suggested on that list that I
> try here.
>
> I have installed the 'cx88_alsa' and 'tuner modules' with modprobe in
> rc.local and, 
>
> alias snd-card-1 cx88-alsa
> options cx88-alsa index=1,  in /etc/modprobe.d/tvtuner
>   

Note: cx88 associated modules do NOT apply to this device (cx88 driver
modules are for the PCI based cx2388x chipsets, where x=0/1,2,3).  This
is a PCIe based device which is serviced, amongst others, by the cx23885
driver module. 

Also, have a look in the wiki for the device article which appears to
contain some info that would be useful for you.

With a hardware encoding device, the /dev/video0 should be the MPEG2
stream whereas /dev/video1 would be the raw stream compatible with apps
like tvtime.  mplayer /dev/video0 should work. .... note that the node
number (N) of the character device (/dev/videoN) will be different if
you have multiple devices installed in the system, so you will have to
adjust accordingly.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
