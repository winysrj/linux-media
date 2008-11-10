Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAKWDDO031095
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:32:13 -0500
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAAKWBfM004034
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 15:32:11 -0500
Date: Mon, 10 Nov 2008 21:32:04 +0100 (CET)
From: Marton Balint <cus@fazekas.hu>
To: Rafael Diniz <diniz@wimobilis.com.br>
In-Reply-To: <200811101023.49872.diniz@wimobilis.com.br>
Message-ID: <Pine.LNX.4.64.0811102035200.3953@cinke.fazekas.hu>
References: <patchbomb.1226272760@roadrunner.athome>
	<200811101023.49872.diniz@wimobilis.com.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 2] cx88: add optional stereo detection to PAL-BG
 mode with A2 sound system
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

Hello,

On Mon, 10 Nov 2008, Rafael Diniz wrote:
> Hello,
> How about audio support in NTSC mode?
> What needs to be done to add support for it?
> I'm using a PlayTV 8000GT, that says to support "Stereo Sound".

Sorry, i am not an expert of the cx88 driver, others may be more familiar 
with it and the status of NTSC stereo support. But unless I am mistaken 
NTSC uses the BTSC audio standard, and if I understand the code correctly, 
this audio standard already has stereo autodetection. If it doesn't 
work for you, maybe you can try a similar approach like mine in PAL-BG 
mode, but probably it won't work.

Regards,
  Marton

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
