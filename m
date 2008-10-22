Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9M02okN022207
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 20:02:50 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9M02ZeK023902
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 20:02:36 -0400
Message-ID: <48FE6D99.5070207@xnet.com>
Date: Tue, 21 Oct 2008 19:02:33 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: Cobus van Rooyen <Cobus.vanRooyen@t-systems.co.za>
References: <9D14A4B03ED2FD43A59EDD4038F9699B1089CDAE@s4zam1syex01.za01.t-systems.com>
In-Reply-To: <9D14A4B03ED2FD43A59EDD4038F9699B1089CDAE@s4zam1syex01.za01.t-systems.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Kworld vs-usb2800d on Fedora 9
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



Cobus van Rooyen wrote:
> Hi;
> I wish I could say I'm a newbie to Linux but alas...  I know enough to
> both enjoy and get myself in trouble when playing with Linux.
>  
> I bought an IR security camera and want to connect it to my laptop which
> will store the video feed via USB.  I use the KWorld vs-usb2800
> <http://www.tigerdirect.com/applications/SearchTools/item-details.asp?Ed
> pNo=612720&Sku=O38-1022>  DVD Maker device.  I think I have sorted out
> ZoneMinder's dependancies but now have a problem with getting a video
> feed.  I see that Clinton
> <http://lists-archives.org/video4linux/22630-kworld-vs-usb2800d.html>
> did get it to work but on 64 bit.  I have tried to follow his steps and
> am short of the v4l-dvb only - can get it next week when I can connect
> my laptop to the 'net again.
>  
> I think however that my problem can be solved without the dvb software -
> I just need to figure out how to modprobe and change the card type. 
>  
> I have tried to modprobe - r but get a "in use" error...
>  
> I'm positive that I will be able to set up my security solution using
> Linux and would be most happy.  Just as an aside - I'm using Fedora
> because it apparently is the only distro currently picking up the EM28xx
> chip but I'm actualy an openSuSE fan.  Does anyone here know if I can
> get it working in openSuSE?
>  
> Below is an excerpt of my dmesg:
>  
> ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
> em28xx #0: Your board has no unique USB ID and thus need a hint to be
> detected.
> em28xx #0: You may try to use card=<n> insmod option to workaround that.
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
> This message and/or attachment(s) may contain privileged or confidential         
> information. If you are not the intended recipient you may not disclose or        
> distribute any of the information contained within this message. In such
> case you must destroy this message and inform the sender of the error.
> T-Systems does not accept liability for any errors, omissions, information
> and viruses contained in the transmission of this message. Any opinions, 
> conclusions and other information contained within this message not related 
> to T-Systems' official business is deemed to be that of the individual only 
> and is not endorsed by T-Systems.        
>                                                                                   
> T-Systems - Business Flexibility
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=subscribe
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
