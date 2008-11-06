Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6NYkbl018665
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:34:49 -0500
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA6NX16I003366
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 18:33:02 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: rs_v4l@rastos.org
In-Reply-To: <4913706A.5090202@rastos.org>
References: <4913706A.5090202@rastos.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 07 Nov 2008 00:31:46 +0100
Message-Id: <1226014306.19661.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: TV @nywhere Plus
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

Hi rastos,

Am Donnerstag, den 06.11.2008, 23:32 +0100 schrieb rs_v4l@rastos.org:
> Hi.
> 
> I would appreciate if anybody can tell me how do I get remote control
> working for "MSI TV @nywhere Plus" TV-card
> 
> http://global.msi.com.tw/index.php?func=proddesc&maincat_no=132∏_no=616
> 
> 
> The card is supported by saa7134 and the tuner itself is (as far as I
> can tell) is TDA827X
> lspci -v -n says
>     02:08.0 0480: 1131:7133 (rev d1)
>             Subsystem: 1462:6231
>     ....
> 
> I run self-configured and compiled vanilla kernel 2.6.27 .
> I was not able to find out whether the remote is supported by Linux.
> Neither dmesg output nor boot messages talk about anything related to
> remote control.
> I also don't recognize whether any entries in /dev or /sys have
> something to do with it.
> 
> Googling yields some old patches that worked for some people and did
> not work for others - but they definitely can't be applied to current
> source code.
> 
> So is there any chance? What should I be looking for?
> --

the patches are only applied at 2.6.28 or you need to install the
current mercurial v4l-dvb at linuxtv.org on older kernels.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
