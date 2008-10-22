Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9M5COOV022223
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 01:12:24 -0400
Received: from tsysmx2.t-systems.co.za (tsysmx2.t-systems.co.za
	[196.13.142.12])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9M5C8FO014034
	for <video4linux-list@redhat.com>; Wed, 22 Oct 2008 01:12:10 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Date: Wed, 22 Oct 2008 07:11:01 +0200
Message-ID: <9D14A4B03ED2FD43A59EDD4038F9699B1089CF19@s4zam1syex01.za01.t-systems.com>
In-Reply-To: <48FE6D99.5070207@xnet.com>
References: <9D14A4B03ED2FD43A59EDD4038F9699B1089CDAE@s4zam1syex01.za01.t-systems.com>
	<48FE6D99.5070207@xnet.com>
From: "Cobus van Rooyen" <Cobus.vanRooyen@t-systems.co.za>
To: "stuart" <stuart@xnet.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: RE: Kworld vs-usb2800d on Fedora 9
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

Stuart;
When I get excited I don't always think straight... :D  

I bought the camera when I was planning on using a desktop instead of
laptop (to be placed inside my ceiling) and then I bought some scrap
laptops at my company which I was able to fix.  A laptop has the
advantage of being light, has a battery when power goes out etc (and the
one I'm using - a T30 Thinkpad's screen is busted so it's perfect).
When my plans was still on using the desktop a coax connection wouldn't
have been a problem but the conversion is now necessary.

It would've been a better buy if I got wireless camera.  I never knew
about 10BaseT - I'll look into it and the advantages you mention is
certainly better but I don't recall seeing any in South Africa.

Thanks for the ideas.


  

-----Original Message-----
From: stuart [mailto:stuart@xnet.com] 
Sent: Wednesday, October 22, 2008 2:03 AM
To: Cobus van Rooyen
Cc: video4linux-list@redhat.com
Subject: Re: Kworld vs-usb2800d on Fedora 9



Cobus van Rooyen wrote:
> Hi;
> I wish I could say I'm a newbie to Linux but alas...  I know enough to
> both enjoy and get myself in trouble when playing with Linux.
>  
> I bought an IR security camera and want to connect it to my laptop
which
> will store the video feed via USB.  I use the KWorld vs-usb2800
>
<http://www.tigerdirect.com/applications/SearchTools/item-details.asp?Ed
> pNo=612720&Sku=O38-1022>  DVD Maker device.  I think I have sorted out
> ZoneMinder's dependancies but now have a problem with getting a video
> feed.  I see that Clinton
> <http://lists-archives.org/video4linux/22630-kworld-vs-usb2800d.html>
> did get it to work but on 64 bit.  I have tried to follow his steps
and
> am short of the v4l-dvb only - can get it next week when I can connect
> my laptop to the 'net again.
>  
> I think however that my problem can be solved without the dvb software
-
> I just need to figure out how to modprobe and change the card type. 
>  
> I have tried to modprobe - r but get a "in use" error...
>  
> I'm positive that I will be able to set up my security solution using
> Linux and would be most happy.  Just as an aside - I'm using Fedora
> because it apparently is the only distro currently picking up the
EM28xx
> chip but I'm actualy an openSuSE fan.  Does anyone here know if I can
> get it working in openSuSE?
>  
> Below is an excerpt of my dmesg:
>  
> ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> em28xx #0: Your board has no unique USB ID and thus need a hint to be
> detected.
> em28xx #0: You may try to use card=<n> insmod option to workaround
that.
> em28xx #0: Please send an email with this log to:
> em28xx #0:  V4L Mailing List <video4linux-list@redhat.com>
> em28xx #0: Board eeprom hash is 0x00000000
> em28xx #0: Board i2c devicelist hash is 0x1ba50080
> em28xx #0: Here is a list of valid choices for the card=<n> insmod
> option:
> em28xx #0:     card=0 -> Unknown EM2800 video grabber
> em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
> em28xx #0:     card=2 -> Terratec Cinergy 250 USB
> em28xx #0:     card=3 -> Pinnacle PCTV USB 2
> em28xx #0:     card=4 -> Hauppauge WinTV USB 2
> em28xx #0:     card=5 -> MSI VOX USB 2.0
> em28xx #0:     card=6 -> Terratec Cinergy 200 USB
> em28xx #0:     card=7 -> Leadtek Winfast USB II
> em28xx #0:     card=8 -> Kworld USB2800
> em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
> em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
> em28xx #0:     card=11 -> Terratec Hybrid XS
> em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
> em28xx #0:     card=13 -> Terratec Prodigy XS
> em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
> em28xx #0:     card=15 -> V-Gear PocketTV
> em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
> ath5k phy0: Atheros AR5213 chip found (MAC: 0x56, PHY: 0x41)
> ath5k phy0: RF5111 5GHz radio found (0x17)
> ath5k phy0: RF2111 2GHz radio found (0x23)
> em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> em28xx #0: Found Unknown EM2750/28xx video grabber
> usbcore: registered new interface driver em28xx
> 
> 
> This message and/or attachment(s) may contain privileged or
confidential         
> information. If you are not the intended recipient you may not
disclose or        
> distribute any of the information contained within this message. In
such
> case you must destroy this message and inform the sender of the error.
> T-Systems does not accept liability for any errors, omissions,
information
> and viruses contained in the transmission of this message. Any
opinions, 
> conclusions and other information contained within this message not
related 
> to T-Systems' official business is deemed to be that of the individual
only 
> and is not endorsed by T-Systems.        
>

> T-Systems - Business Flexibility
> --
> video4linux-list mailing list
> Unsubscribe
mailto:video4linux-list-request@redhat.com?subject=subscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 

Humm, maybe I'm way off here, but don't you want to use the GSPCA 
USB/Webcam driver?  But you are using a kworld composite to USB adaptor.

  Ok, maybe not.

But, I've got to ask - why the combo (coax camera & coax->usb/adaptor)?

You can buy 10BaseT internet cameras for prob ~$50 and wireless versions

for prob ~$80 on sale.  I was doing this w/zoneMinder for a while.  Been

thinking of putting it back on line recently.  W/Ethernet, you can place

cameras a good distance from the computer.  W/USB you are limited w/o 
USB extension hardware.

USB cameras are also tricky.  The support is there for common chip sets.

  But I don't know about the kworld usb device.  When I plug a USB 
camera into my Debian / mythtv system, it shows up as a 
/dev/video<something>.  Unfortunately this messes w/the TV tuner cards 
and breaks the mythtv / back end feature.

I don't remember any of these problems while using wireless or cabled 
Ethernet cameras.  At the time I was more concerned I wasn't getting the

results from zoneMinder I had expected (false triggering or triggering 
due to wind blowing trees around).

Alternatively (I was looking into this as well) I was thinking of 
creating a cluster of low cost USB cameras in remote locations and using

something like a NSLU2 (correct name? a.k.a. SLUG) to manage and bridge 
the camera cluster onto my 10BaseT network.  I had thought seriously 
about this as I think a 3 USB camera cluster + used SLUG would not 
exceed the cost of 1 wireless 802.11b camera.

Let us know how it goes...
This message and/or attachment(s) may contain privileged or confidential         
information. If you are not the intended recipient you may not disclose or        
distribute any of the information contained within this message. In such
case you must destroy this message and inform the sender of the error.
T-Systems does not accept liability for any errors, omissions, information
and viruses contained in the transmission of this message. Any opinions, 
conclusions and other information contained within this message not related 
to T-Systems' official business is deemed to be that of the individual only 
and is not endorsed by T-Systems.        
                                                                                  
T-Systems - Business Flexibility

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
