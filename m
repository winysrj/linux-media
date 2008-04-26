Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3QBv0a1002821
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 07:57:00 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3QBugFr005716
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 07:56:42 -0400
Received: by ug-out-1314.google.com with SMTP id t39so262839ugd.6
	for <video4linux-list@redhat.com>; Sat, 26 Apr 2008 04:56:41 -0700 (PDT)
From: "Ben Garside" <ben@farsidegarside.com>
To: <video4linux-list@redhat.com>
Date: Sat, 26 Apr 2008 12:56:44 +0100
Message-ID: <058b01c8a794$9a2ba890$ce82f9b0$@com>
MIME-Version: 1.0
Content-Language: en-gb
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Dvico Dual Digital 4 in the UK
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

Would be great if you could give me some help. Had this working before but
under a v old set of patch files (some of which I seem to remember I
hacked). Am based in the UK, so possibly different set of
frequencies/firmware??

 

Have just upgraded to Ubuntu 8.04. Installed the vanilla latest v4l-dvb
drivers, and found I only got one adapter showing (/dev/dvb/adapter0), then
found updated instructions on this page:
http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/ which I followed. Great,
my dmesg now shows everything loaded! :

[   52.207188] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully
initialized and connected.

[  134.380618] xc2028 1-0061: Loading 3 firmware images from
xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7

 

It is picking up the version 2.7 firmware, however when I try to scan the
channels in mythtv I get nothing. Have also tried using the scan command
with the same result.

 

Any ideas??

 

Thanks

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
