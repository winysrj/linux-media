Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5DF5Qr3016894
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 11:05:27 -0400
Received: from imo-d22.mx.aol.com (imo-d22.mx.aol.com [205.188.144.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5DF5FwQ006392
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 11:05:15 -0400
Received: from DrDiettrich1@aol.com
	by imo-d22.mx.aol.com (mail_out_v38_r9.4.) id e.be5.32c67d92 (37224)
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 11:05:05 -0400 (EDT)
Message-ID: <485273BB.6040608@aol.com>
Date: Fri, 13 Jun 2008 15:18:51 +0200
From: Hans-Peter Diettrich <DrDiettrich1@aol.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Medion problem
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

Preface: I'm very new to Linux :-(

My Medion PC6610 comes without any Linux support, what I only noticed 
when I started to move from Vista to Linux (openSUSE 10.3 32/64 bit).

The TV card is a proprietary Medion (Philips?) card, detected as:
1) SAA7134/SAA7135HL Video Broadcast Decoder
2) Medion 7134

With the installed driver saa7134 I can configure the TV channels for 
the second (Medion 7134) entry only, in the Yast2 TV card setup. The 
detected channels (PAL, analog, cable) are stored in /etc/X11/xawtvrc. 
NxtVEPG also works fine with that entry :-)

But none of the TV applications seems to come in contact with either 
device, most applications simply refuse to start (no window after some 
seconds of activity). Only Kdetv opens a window, with two Video card 
options:
1) Video4Linux2: Medion 7134 Bridge #2
2) Video4Linux2: Medion 7134

but it displays only noise for the first entry, nothing at all for the 
second one. Channel selection has no effect, even if I could manage 
(somehow) to fill the channel list, with channels only (no providers).

Another complication may be the graphics card, a Nvidia GeForce 8500GT, 
which works fine together with the TV card under Vista. It seems to work 
properly under Linux as well, with the proprietary Nvidia driver, even 
with two monitors, but it may cause the Linux TV apps to fail?
Even nvtv 0.4.7 only says: No supported video card found.

Also all the diagnostic tools fail to provide meaningful information, at 
least to me <g>. If you think that it's worth the time, I can provide 
more information...

DoDi

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
