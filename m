Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKImn05007735
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 13:48:49 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAKImZh1007931
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 13:48:35 -0500
Received: by ug-out-1314.google.com with SMTP id j30so375197ugc.13
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 10:48:34 -0800 (PST)
From: Thomas Reiter <x535.01@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811190550i607a740bgae6348ac69253d7d@mail.gmail.com>
References: <1226943947.6362.10.camel@ivan>
	<09CD2F1A09A6ED498A24D850EB101208165C79D3B1@Colmatec004.COLMATEC.INT>
	<b24afa610811180959q285f52abv7eb196e26e8d5c6b@mail.gmail.com>
	<412bdbff0811190550i607a740bgae6348ac69253d7d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 19:48:31 +0100
Message-Id: <1227206911.6617.6.camel@ivan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: Re: RE : DVB-T2 (Mpeg4) in Norway
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

on., 19.11.2008 kl. 08.50 -0500, skrev Devin Heitmueller:
> If you're running the latest v4l-dvb, then you need the dib0700 1.20
> firmware, and it's available here.
> 
>  http://devinheitmueller.com/801e/dvb-usb-dib0700-1.20.fw


I tried this firmware but a scan gave the following result for my
Pinnacle Nano (73e):

>  scan -c -a 0 -f 0 -d 0 -l 45000000,800000000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
dumping lists (0 services)
Done.



dmesg has the output (the firmware file is  a link to 1.20): 

[ 1675.457804] dvb-usb: found a 'Pinnacle PCTV 73e' in cold state, will
try to load a firmware
[ 1675.457812] firmware: requesting dvb-usb-dib0700-1.10.fw
[ 1675.460700] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[ 1675.685934] dib0700: firmware started successfully.
[ 1676.188024] dvb-usb: found a 'Pinnacle PCTV 73e' in warm state.
[ 1676.188076] dvb-usb: will pass the complete MPEG2 transport stream to
the software demuxer.
[ 1676.188455] DVB: registering new adapter (Pinnacle PCTV 73e)
[ 1676.398963] DVB: registering frontend 0 (DiBcom 7000PC)...
[ 1676.571841] DiB0070: successfully identified

My system is an Unbuntu 8.10



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
