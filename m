Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6PARekM014090
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 06:27:40 -0400
Received: from akbkhome.com (246-113.netfront.net [202.81.246.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6PARGB8019836
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 06:27:16 -0400
Received: from awork064158.netvigator.com ([203.198.249.158]
	helo=[192.168.1.96])
	by akbkhome.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69) (envelope-from <alan@akbkhome.com>) id 1KMKW9-0003L0-PM
	for video4linux-list@redhat.com; Fri, 25 Jul 2008 18:27:22 +0800
Message-ID: <4889AA61.8040006@akbkhome.com>
Date: Fri, 25 Jul 2008 18:26:41 +0800
From: Alan Knowles <alan@akbkhome.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48898289.2070305@akbkhome.com>
In-Reply-To: <48898289.2070305@akbkhome.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: ASUS  My Cinema-U3100Mini/DMB-TH  (Legend Slilicon 8934)
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

Just a small update on this - I suspect ASUS released the wrong tarball 
for this device - as comparing the output from 'strings dib3000mc.ko' to 
the source code finds quite a few things missing..

Waiting on a response from ASUS now.

Regards
Alan

Alan Knowles wrote:
> I've been looking at the drivers for  My Cinema-U3100Mini/DMB-TH
>
> The source is available directly from ASUS now. 
> http://dlcdnet.asus.com/pub/ASUS/vga/tvtuner/source_code.zip
>
> I've diffed it to the version they have used, and applied it, and 
> fixed it against the current source
> http://www.akbkhome.com/svn/asus_dvb_driver/v4l-dvb-diff-from-current.diff 
>
>
> In addition there are the drivers for the ADI MTV102 silicon tuner driver
> http://www.akbkhome.com/svn/asus_dvb_driver/frontends/
> (all the adimtv* files)
>
> The source code appears to use a slightly differ usb stick to the 
> one's I have.
> 0x1748  (cold)  / 0x1749 (warm)
> where as I've got
> 0x1721(cold) /  0x1722 (warm)
>
> It looks like they hacked up dib3000mc.c, rather than writing a new 
> driver
>
> I've got to the point where it builds, firmware installs etc. 
> (firmware is available inside the deb packages)
> http://dlcdnet.asus.com/pub/ASUS/vga/tvtuner/asus-dmbth-20080528_tar.zip
>
> The driver initializes correctly when plugged in.
> [302520.686782] dvb-usb: ASUSTeK DMB-TH successfully deinitialized and 
> disconnected.
> [302530.550018] dvb-usb: found a 'ASUSTeK DMB-TH' in warm state.
> [353408.577741] dvb-usb: will pass the complete MPEG2 transport stream 
> to the software demuxer.
> [353408.680977] DVB: registering new adapter (ASUSTeK DMB-TH)
> [302530.670387]  Cannot find LGS8934
> [302530.670596] DVB: registering frontend 0 (Legend Slilicon 8934)...
> [302530.670668] adimtv102_readreg 0x00
> [302530.676090] adimtv102_readreg 0x01
> [302530.681578] adimtv102_readreg 0x02
> [302530.687077] adimtv102: successfully identified (ff ff ff)
> [302530.688577] dvb-usb: ASUSTeK DMB-TH successfully initialized and 
> connected.
> [302530.688624] usbcore: registered new interface driver 
> dvb_usb_dibusb_mc
> [353413.776593] adimtv102_init
>
> when w_scan is run, it outputs activity...
> [353416.533576] lgs8934_SetAutoMode!
> [353416.553928] lgs8934_auto_detect!
> [353418.285686] lgs8934_auto_detect, lock 0
> [353418.285686] adimtv102_set_params freq=184500
> [353418.378803] MTV102>>tp->freq=184 PLLF=d8000 PLLFREQ=1472000  
> MTV10x_REFCLK=16384 !
> ......
>
> however fails to pick up any channels...
>
> I'm trying to connect to these -
> http://en.wikipedia.org/wiki/Digital_television_in_Hong_Kong
>
> Any ideas welcome..
>
> Regards
> Alan
>
> -- 
> video4linux-list mailing list
> Unsubscribe 
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
