Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4EHHcT2015760
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 13:17:38 -0400
Received: from scing.com (scing.com [217.160.110.58])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4EHHL7g013799
	for <video4linux-list@redhat.com>; Wed, 14 May 2008 13:17:22 -0400
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Wed, 14 May 2008 19:17:51 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805141917.52078.janne-dvb@grunau.be>
Cc: directhex@apebox.org, video4linux-list@redhat.com
Subject: Compro S300/S350 linux driver violates the GPL
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

Hi,

a mythtv user discovered that compro offers linux drivers for at least 
one of their products. After selecting S350/S300 on 
http://www.comprousa.com/en/download/sseries.html they offer a complete 
linux kernel rpm for Mandriva Linux 2007 Spring for downbload.

We haven't found any hint of the GPL, source code or an offer to get the 
source code. We have sent a request for the source code but only after 
Taiwan buisness hours.

The kernel version is 2.6.17. From a quick inspection only two modules 
are modified by Compro, no additional modules. The modified modules are 
media/video/tuner.ko (from 65kb to 148kb) and 
media/video/cx88/cx88xx.ko (from 66kb to 142kb). That else to expect 
from a vendor binary only driver.

There are two new product names "Compro VideoMate TV X" and "VideoMate 
TV X Xceive xc2028".

Janne

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
