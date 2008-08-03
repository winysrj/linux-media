Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m739DXo5014305
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 05:13:33 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m739DL0W002875
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 05:13:21 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Brian Rogers <brian_rogers@comcast.net>
In-Reply-To: <48954612.7000906@comcast.net>
References: <48954612.7000906@comcast.net>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 03 Aug 2008 10:33:51 +0200
Message-Id: <1217752431.1714.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: gspca "scheduling while atomic" crash
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

On Sat, 2008-08-02 at 22:45 -0700, Brian Rogers wrote:
> I have the following device:
> Bus 007 Device 002: ID 0c45:60fc Microdia PC Camera with Mic (SN9C105)
> 
> Whether I build 2.6.27-rc1 or merge the stable branch of 
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git 
> into my Intrepid kernel (2.6.26), the system will lock up when I try to 
> get video from my webcam.
> 
> To see the kernel output, I do this in the console:
> mplayer -ao aa -tv device=v4l2:width=640:height=480:fps=30 tv://
> 
> The result is a rapid stream of two alternating messages:
> BUG: scheduling while atomic: swapper/0/0x8001???? (didn't get it all)
> bad: scheduling from the idle thread!
> 
> During this the system doesn't respond to anything. It's a Core2 Duo 
> running 64-bit Ubuntu Intrepid with 4GB of RAM. What other info should I 
> provide to investigate this problem?

Hello Brian,

I think I saw the problem: usb_control_msg() is called at interrupt
level..

I hope to have a patch this morning.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
