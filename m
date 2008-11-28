Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mASA9SlD008771
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 05:09:28 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mASA9Hgt002987
	for <video4linux-list@redhat.com>; Fri, 28 Nov 2008 05:09:17 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Gordon Smith <spider.karma+video4linux-list@gmail.com>
In-Reply-To: <2df568dc0811271017h1598b038g6f21e92b005538a@mail.gmail.com>
References: <2df568dc0811271017h1598b038g6f21e92b005538a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 28 Nov 2008 10:52:52 +0100
Message-Id: <1227865972.1769.55.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Advice needed: gspca IR LED control
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

On Thu, 2008-11-27 at 11:17 -0700, Gordon Smith wrote:
> Hello everyone,

Hello Gordon,

> I have a Z-Star Microelectronics Corp. ZC0305 USB WebCam that works fine
> during daylight with the gspca webcam driver.
> I'd like to turn on the IR LED's on the webcam for nighttime capture and it
> looks like the driver doesn't have that capability.
> 
> Any advice on how to find out how to control the LED's?

If I know the right sequence to send to the webcam, I may add an IR
control.

> In addition to Linux, I have a windows machine with the capture software
> that came with the webcam that turns on the LED's during capture.
> Would it be difficult to capture and interpret USB traffic on the windows
> machine?

Fine! May you send me such a USB trace? (I better like text traces as
those done by sniffbin)

Thank you.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
