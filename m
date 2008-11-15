Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAFIsBcV000872
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 13:54:11 -0500
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAFIrxjl024631
	for <video4linux-list@redhat.com>; Sat, 15 Nov 2008 13:53:59 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
In-Reply-To: <200811151218.45664.m.kozlowski@tuxland.pl>
References: <200811151218.45664.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 15 Nov 2008 19:48:33 +0100
Message-Id: <1226774913.1706.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: Re: [BUG] zc3xx oopses on unplug: unable to handle kernel paging
	request
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

On Sat, 2008-11-15 at 12:18 +0100, Mariusz Kozlowski wrote:
> Hi,
> 
> 	Recently I bought one of these cheap usb cameras. This would be
> Logitech e1000 identified as 046d:08af Logitech, Inc. It doesn't quite
> work but that's another story. On unplug though it causes oops
> while /dev/video is open. 
> 
> Steps to reproduce: 
> 
> a) plug the camera in (zc3xx as a module)
> b) wait for it to settle down
> c) cat /dev/video > /dev/null
> d) unplug the camera

Hi Mariusz,

Do you have the same oops when streaming by mmap (most apps) or by
userptr (svv)?

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
