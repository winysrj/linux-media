Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n33HHcxb002431
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 13:17:38 -0400
Received: from node01.cambriumhosting.nl (node01.cambriumhosting.nl
	[217.19.16.162])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n33HHHte027039
	for <video4linux-list@redhat.com>; Fri, 3 Apr 2009 13:17:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by node01.cambriumhosting.nl (Postfix) with ESMTP id A2C54B000087
	for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 19:17:16 +0200 (CEST)
Received: from node01.cambriumhosting.nl ([127.0.0.1])
	by localhost (node01.cambriumhosting.nl [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id WQ4ghaoLcIUV for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 19:17:11 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl
	[84.245.3.195])
	by node01.cambriumhosting.nl (Postfix) with ESMTP id 0AEDAB0000BD
	for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 19:17:11 +0200 (CEST)
Received: from [192.168.1.239] (unknown [192.168.1.239])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id 65A9A23BC501
	for <video4linux-list@redhat.com>;
	Fri,  3 Apr 2009 18:46:11 +0200 (CEST)
Message-ID: <49D644CD.1040307@powercraft.nl>
Date: Fri, 03 Apr 2009 19:18:05 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: one dvb-t devices not working with mplayer the other is, what is
 going wrong?
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

Hello everybody,

As you may read in my previous thread, i am trying to switch from my
em28xx devices to a device that works with gpl compliant upstream kernel
source code.

My em28xx devices all played back video and audio only dvb-t channels:
Pinnacle PCTV Hybrid Pro Stick 330e
Terratec Cinergy Hybrid T USB XS
Hauppauge WinTV HVR 900

I build script for this to automate the process, however i now swiched to
my dvb-t only usb device:
Afatech AF9015 DVB-T USB2.0 stick

And it with totem-xine it plays the same as the em28xx devices, so the
devices does kind of works (see the totem-xine bug, please commit to this
bug if you have the same behavior)

# device info
http://debian.pastebin.com/d3e942c02

# totem-xine bug
http://bugzilla.gnome.org/show_bug.cgi?id=554319

# mplayer issue
http://debian.pastebin.com/d34d92e64
^ anybody have any idea what the heck goes on why doesn't mplayer work
with this device, nothing changed in the commands i used.

using:
mplayer
Version: 1:1.0.rc2svn20090330-0.0
linux-image-2.6.29-1-686
Version: 2.6.29-1

Thanks in advance, for any help.

Best regards,

Jelle de Jong

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
