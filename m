Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:55455 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbZCZEPH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 00:15:07 -0400
Message-ID: <49CB0146.9040507@blueyonder.co.uk>
Date: Thu, 26 Mar 2009 04:15:02 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: gspca: Logitech QuickCam Messenger no go (was Re: Asus PG221
 monitor camera sensor not recognised)
References: <Pine.LNX.4.64.0903252026380.5795@axis700.grange> <49CA9228.5030105@gmail.com> <49CABAF8.4030306@blueyonder.co.uk> <Pine.LNX.4.64.0903260022450.5795@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903260022450.5795@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> sorry for hijacking the thread, just a quick notice to say, that my 
> Logitech QuickCam Messenger webcam (USB_DEVICE(0x046d, 0x08da)) is not 
> working with recent kernels either, but, it used to work with out-of-tree 
> gspca, I think, gspcav1-20071224 did work (I might still be able to bring 
> up the machine with which I used it back then and even boot that kernel), 
> so, it shouldn't be very difficult to fix it again. I noticed, that that 
> older version used a different sensor with this camera, so, I tried 
> "force_sensor=tas5130cxx" with 2.6.28, but it didn't help either.
> 
> Notice, this is not very high priority for me, that's why I'm only 
> reporting it now, but it would be good to have it fixed some time...
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 
> 

I shall subscribe to linux-media. Earlier kernels said it found the
sensor, but it did not work. In order to provide a usbsnoop dump, I
would have to borrow a Windows box or try installing Windows in a
VirtualBox VM and doing it that way hopefully. At present I am having a
problem getting VirtualBox to start on this box, something is strange as
certain apps when started as root stall at futex(0x69db9c,
FUTEX_WAIT_PRIVATE, 1, NULL for VirtualBox and same type of problem with
qjackctl while they work as user. VirtualBox however now fails to start
as user with:-
 lancelot@tindog:~/ftp/Mar09/JAVA-SDR/Radio/Radio> VirtualBox
/usr/bin/VirtualBox: line 72: /usr/lib/virtualbox/VirtualBox: Permission
denied
/usr/bin/VirtualBox: line 72: exec: /usr/lib/virtualbox/VirtualBox:
cannot execute: Success
Looks like I shall have to do a fresh install as problem carried over
from a hard drive with bad blocks and a shutdown due to watercooling
failure.

Likewise it's not critical as I have a Logitech Pro 9000 that has always
worked with the uvcvideo driver.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

