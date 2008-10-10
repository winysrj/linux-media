Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ACBBUH001515
	for <video4linux-list@redhat.com>; Fri, 10 Oct 2008 08:11:11 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9AC9YSi026621
	for <video4linux-list@redhat.com>; Fri, 10 Oct 2008 08:09:35 -0400
Received: by nf-out-0910.google.com with SMTP id d3so245343nfc.21
	for <video4linux-list@redhat.com>; Fri, 10 Oct 2008 05:09:34 -0700 (PDT)
From: "luisan82@gmail.com" <luisan82@gmail.com>
To: linux-dvb@linuxtv.org, video4linux-list@redhat.com
Date: Fri, 10 Oct 2008 14:09:08 +0200
Message-Id: <1223640548.5171.64.camel@luis>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: 
Subject: analize ASI with dvbnoop and dektec 140
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

I've been trying to analyze a ts with dvbsnoop through an ASI input
unsuccessfully.
When I execute dvbsnoop, it tries to read from a location (/dev/dvb/...)
wich doesn't exists.

# dvbsnoop -s pidscan
dvbsnoop V1.4.52 -- http://dvbsnoop.sourceforge.net/ 

---------------------------------------------------------
Transponder PID-Scan...
---------------------------------------------------------
Error(2): /dev/dvb/adapter0/dvr0: No such file or directory

My /dev contains the following:

bus/        Dta1xx1     Dta1xx5     Dta1xx9     loop/       pts/
disk/       Dta1xx2     Dta1xx6     fd/         MAKEDEV     shm/
dri/        Dta1xx3     Dta1xx7     .initramfs/ mapper/     .static/
Dta1xx0     Dta1xx4     Dta1xx8     input/      net/        .udev/

Dektec commands are located at: /home/optiva/DTA1xx/LinuxSDK_feb08/

Dta1xx/    Dta1xxNw/  DTAPI/     DtPlay/    DtRecord/  DtRmxUtil/
Dtu2xx/

I think may be two alternatives to solve this (at least). First one and
cleaner is to have drivers and dektec software installed as must, that
is drivers at /dev/dvb and software at /usr (included in the path). The
other way could be use the dvb options to select the appropriate device,
but I've no idea how to use it.

 -demux device: demux device [/dev/dvb/adapter0/demux0]
   -dvr device:   dvr device [/dev/dvb/adapter0/dvr0]
   -frontend device: frontend   device [/dev/dvb/adapter0/frontend0]
   -adapter n:    select dvb adapter/card no. <n> using default path
   -devnr n:      select device no. <n> using default dvb adapter/card
 
Thanks in advance,

Luis Martinez
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
