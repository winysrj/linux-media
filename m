Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA6MXnfg026392
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 17:33:49 -0500
Received: from ras.rastos.org (dial-78-141-81-242-orange.orange.sk
	[78.141.81.242])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA6MWMGO008341
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 17:32:46 -0500
Received: from [192.168.2.221] (ras.rastos.org [192.168.2.221])
	by ras.rastos.org (8.14.2/8.13.3) with ESMTP id mA6MWAo3015757
	for <video4linux-list@redhat.com>; Thu, 6 Nov 2008 23:32:10 +0100
Message-ID: <4913706A.5090202@rastos.org>
Date: Thu, 06 Nov 2008 23:32:10 +0100
From: rs_v4l@rastos.org
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: TV @nywhere Plus
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

Hi.

I would appreciate if anybody can tell me how do I get remote control
working for "MSI TV @nywhere Plus" TV-card

http://global.msi.com.tw/index.php?func=proddesc&maincat_no=132&prod_no=616


The card is supported by saa7134 and the tuner itself is (as far as I
can tell) is TDA827X
lspci -v -n says
    02:08.0 0480: 1131:7133 (rev d1)
            Subsystem: 1462:6231
    ....

I run self-configured and compiled vanilla kernel 2.6.27 .
I was not able to find out whether the remote is supported by Linux.
Neither dmesg output nor boot messages talk about anything related to
remote control.
I also don't recognize whether any entries in /dev or /sys have
something to do with it.

Googling yields some old patches that worked for some people and did
not work for others - but they definitely can't be applied to current
source code.

So is there any chance? What should I be looking for?
--
    Thanks
       rastos

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
