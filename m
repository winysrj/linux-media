Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QKATfk032689
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:10:29 -0400
Received: from jade.aracnet.com (jade.aracnet.com [216.99.193.136])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QK9jhO018931
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:09:46 -0400
Received: from sandbox.nvr.com (216-99-218-74.dsl.aracnet.com [216.99.218.74])
	(authenticated bits=0)
	by jade.aracnet.com (8.13.6/8.12.8) with ESMTP id m4QK9i6r017922
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 13:09:44 -0700
Message-ID: <483B1908.7000609@nvr.com>
Date: Mon, 26 May 2008 13:09:44 -0700
From: Todd Brunhoff <toddb@nvr.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [resend] XC5000 firmware for Pinnacle 800i
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

Recently I installed mythtv on fedora core 8 using yum for most of the 
packages and v4l for the dvb support (v4l-dvb-fee5c2458384.tar.gz). I 
have the Pinnacle 800i, and the drivers for the cx88 installed 
correctly, and the firmware from http://www.steventoth.net/linux/xc5000 
always loaded. The problem was that nothing could detect any atsc 
reception, including myth setup and dvb-atsc-tools-1.0.7. After 
eliminating the antenna, cable, configuration, and rebooting many times, 
I finally humbled myself and booted up XP and installed the drivers that 
came with the card. Atsc reception worked.

So then going back to linux, I find that myth setup detected all the 
channels, and everything works!

Keep in mind that I have little experience with myth or v4l or the 
drivers, so take this with a grain of salt... in my experience 
(elsewhere) this suggests a couple of explanations:

    * the windows drivers installed the firmware correctly (making it 
work). At the very least, it had some positive influence.
    * the board logic retains a firmware installation and is smart 
enough to detect an invalid firmware update (which makes it work under 
linux in spite of bad firmware being loaded or loaded incorrectly).
    * If the firmware is bad, this could be the shell script (which 
extracts the firmware by dd'ing it out of the middle of a .sys file) 
doesn't get quite the right bytes). This seems unlikely since it 
probably worked for the author.
    * It could be that the firmware is the wrong version for the 800i 
(the readme that comes with the firmware says that it is the official 
Haupauge WHQL driver).
    * It also could be possible that the linux firmare is correct, but 
that the windows driver did some other operation to the board (like 
updating other firmware), that then allows the linux driver firmware 
load to work correctly.

It would be nice is one of you could shed some light on this, although 
for me this problem is solved. Perhaps this may help others get past the 
same very irritating brick wall with the 800i.

Todd

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
