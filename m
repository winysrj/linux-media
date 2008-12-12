Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBCFQSq2022568
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 10:26:28 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBCFQDos023011
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 10:26:13 -0500
Received: by fg-out-1718.google.com with SMTP id e21so716979fga.7
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 07:26:12 -0800 (PST)
Message-ID: <412bdbff0812120726n34d11265xe13f1faae2395ec3@mail.gmail.com>
Date: Fri, 12 Dec 2008 10:26:12 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: brucetheturboguy@yahoo.com
In-Reply-To: <724114.61792.qm@web51406.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <724114.61792.qm@web51406.mail.re2.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: HVR950Q no /dev/video0
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

On Fri, Dec 12, 2008 at 3:21 AM, Bruce Ascroft
<brucetheturboguy@yahoo.com> wrote:
> Hi all,
>
> I don't know if this is an appropriate list to post this question to, but, I'm kinda frustrated and figger what the hell.
>
> I've got the Hauppauge HVR-950Q and I'm currently running intrepid ibex on a number of machines (desktop and laptop).  The card is recognized but there is no /dev/video0 created.  I've confirmed that the device works correctly in M$.  I've tried the bleeding edge V4l, and  the firmware is correct.
>
> I've read til my eyes bled, but no luck, and yet I see on this list that
> people have found that the device works "out of the box". sigh.  I would
> certainly appreciate any input or advice.
>
> Let me know if I should supply any additional info to help diagnose.
>
> Thanks,
> Bruce.
>
> relevant dmesg output:
>
> [84420.692041] usb 3-3: new high speed USB device using ehci_hcd and address 3
> [84420.846764] usb 3-3: configuration #1 chosen from 1 choice
> [84421.204817] au0828: i2c bus registered
> [84421.302531] tveeprom 0-0050: Hauppauge model 72001, rev B3F0, serial#
> 4756341
> [84421.302537] tveeprom 0-0050: MAC address is 00-0D-FE-48-93-75
> [84421.302539] tveeprom 0-0050: tuner model is Xceive XC5000 (idx 150, type 4)
> [84421.302542] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom
> 0x88)
> [84421.302546] tveeprom 0-0050: audio processor is AU8522 (idx 44)
> [84421.302548] tveeprom 0-0050: decoder processor is AU8522 (idx 42)
> [84421.302551] tveeprom 0-0050: has no radio, has IR receiver, has no IR
> transmitter
> [84421.302553] hauppauge_eeprom: hauppauge eeprom: model=72001
> [84421.307962] xc5000 0-0061: creating new instance
> [84421.310152] xc5000: Successfully identified at address 0x61
> [84421.310156] xc5000: Firmware has not been loaded previously
> [84421.310159] DVB: registering new adapter (au0828)
> [84421.310162] DVB: registering adapter 0 frontend 0 (Auvitek AU8522 QAM/8VSB
> Frontend)...
> [84421.310479] Registered device AU0828 [Hauppauge HVR950Q]
>
> b@crankshaft:/dev$ lsusb
> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 007 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 003: ID 2040:7200 Hauppauge
> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>
> b@crankshaft:/dev$ ls -l /dev/dvb/adapter0/
> total 0
> crw-rw---- 1 root video 212, 1 2008-12-11 22:42 demux0
> crw-rw---- 1 root video 212, 2 2008-12-11 22:42 dvr0
> crw-rw---- 1 root video 212, 0 2008-12-11 22:42 frontend0
> crw-rw---- 1 root video 212, 3 2008-12-11 22:42 net0

Hello Bruce,

The analog support for the HVR-950Q is not yet implemented.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
