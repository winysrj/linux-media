Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBR9e3uh026736
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 04:40:03 -0500
Received: from outbound.mail.nauticom.net (outbound.mail.nauticom.net
	[72.22.18.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBR9dkB9028076
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 04:39:46 -0500
Received: from [192.168.0.124] (27.craf1.xdsl.nauticom.net [209.195.160.60])
	(authenticated bits=0)
	by outbound.mail.nauticom.net (8.13.8/8.13.8) with ESMTP id
	mBR9djDU068294
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 04:39:45 -0500 (EST)
From: Rick Bilonick <rab@nauticom.net>
To: video4linux-list <video4linux-list@redhat.com>
In-Reply-To: <1230359011.3450.88.camel@localhost.localdomain>
References: <1230233794.3450.33.camel@localhost.localdomain>
	<20081226010307.2c7e3b55@gmail.com>
	<1230269443.3450.48.camel@localhost.localdomain>
	<20081226174129.7c752fc6@gmail.com>
	<1230353764.3450.79.camel@localhost.localdomain>
	<1230359011.3450.88.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 27 Dec 2008 04:39:45 -0500
Message-Id: <1230370785.3450.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Compiling v4l-dvb-kernel for Ubuntu and for F8
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


On Sat, 2008-12-27 at 01:23 -0500, Rick Bilonick wrote:
> On Fri, 2008-12-26 at 23:56 -0500, Rick Bilonick wrote:
> > 
> > So far, I haven't been able to find dvb-fe-xc5000-1.1.fw. (I had
> > previously installed a firmware file (version 4), but apparently the
> > needed firmware is not in the tar file.
> > 
> > Thanks for the help. I'm going to continue looking for the firmware.
> > 
> > I'm not sure if this firmware is absolutely necessary given it appears
> > to be the IR receiver. I am trying to use xine (I have a channel.conf
> > file that I created for a different tuner in another computer) but so
> > far have not gotten xine to display the digital signal.
> > 
> > Rick B.
> > 
> 
> OK, I found the firmware on-line via MythTV
> ( http://www.mythtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_(800i)#Firmware ) at http://www.steventoth.net/linux/xc5000 . (I guess I could have taken this from the CD that came with the tuner.) This contains the the windows drivers with a shell script to extract the firmware (both for the tuner and the ir receiver - the device apparently won't work without both pieces of firmware). So the device now works on the HP2133 mini-notebook running Ubuntu 8.10. Now onto getting this to run on Fedora 8 and 10. Douglas, thanks for your help.
> 
> Rick B.


v4l-dvb compiled and installed perfectly on Fedora 8. (For Ubuntu 8.10,
there were a few warning messages but it still worked fine. There were
no warning messages for Fedora 8.) Xine works fine for Fedora 8.

Unfortunately, there are some errors for Fedora 10. I will post them as
soon as possible.

Rick B.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
