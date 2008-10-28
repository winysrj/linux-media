Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9S8fEgA000964
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:41:14 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9S8f2Hl023436
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 04:41:03 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Gatis <gatisl@inbox.lv>
In-Reply-To: <1225182362.4906cc9a38cb1@www.inbox.lv>
References: <1225182362.4906cc9a38cb1@www.inbox.lv>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 28 Oct 2008 09:37:41 +0100
Message-Id: <1225183061.1729.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Creative Vista IM (VF0420) - green pictures
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

On Tue, 2008-10-28 at 10:26 +0200, Gatis wrote:
> Hello!

Hello Gatis,

> I set up usb webcam [ Creative Live! Cam Vista IM (VF0420) ] with
> "EasyCam" automatic driver installer. OS - Ubuntu 8.
> I use v4lctl command line tool to periodically take snapshots:
> v4lctl snap jpeg full test.jpg
> Problem:
> 20% of taken pictures are heavily colored in green. This is true also
> when using xawtv. I couldn't find any connection between start of this
> problem and any surrounding conditions. If I restart PC, or cover
> webcam with hand for a while, webcam returns to normal operation.
> When tested with official windows drivers on winXP, there was no such
> problems.
> Question:
> Is this driver, camera or settings problem?
	[snip]

May you give more information:
- what is the version of your kernel?
- what driver do you use?
- what are the (20) last lines of dmesg after your plug the webcam?

Regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
