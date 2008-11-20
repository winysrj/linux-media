Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAKKuktX027433
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 15:56:46 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAKKuXbE026223
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 15:56:33 -0500
Received: by nf-out-0910.google.com with SMTP id d3so329218nfc.21
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 12:56:33 -0800 (PST)
From: Thomas Reiter <x535.01@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811201051u22fc5a32if0b241c36ddf81b3@mail.gmail.com>
References: <1226943947.6362.10.camel@ivan>
	<09CD2F1A09A6ED498A24D850EB101208165C79D3B1@Colmatec004.COLMATEC.INT>
	<b24afa610811180959q285f52abv7eb196e26e8d5c6b@mail.gmail.com>
	<412bdbff0811190550i607a740bgae6348ac69253d7d@mail.gmail.com>
	<1227206911.6617.6.camel@ivan>
	<412bdbff0811201051u22fc5a32if0b241c36ddf81b3@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 21:56:29 +0100
Message-Id: <1227214589.7054.6.camel@ivan>
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

to., 20.11.2008 kl. 13.51 -0500, skrev Devin Heitmueller:

> 
> Your system is still trying to load version 1.10 of the firmware.
> Have you installed the latest v4l-dvb code by following the directions
> on http://linuxtv.org/repo ?  If so, have you rebooted the computer
> since then (so modules get unloaded).
> 
> Devin

Thanks, I've got a list with stations now. It was my fault not to
upgrade v4l and the docs for "scan" aren't very helpful. So I tried to
scan without a startup scan file with one single frequency. After I
realized that was the problem I've got a bunch of stations. 



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
