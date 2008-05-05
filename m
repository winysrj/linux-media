Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45MM62w006587
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 18:22:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m45MLoLQ002286
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 18:21:50 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: "zied frikha" <frikha.zied@gmail.com>
Date: Tue, 6 May 2008 00:21:43 +0200
References: <20080428160019.AB5306186B3@hormel.redhat.com>
	<74a5bce60804290637k21f2465ajed607224a8fe764b@mail.gmail.com>
In-Reply-To: <74a5bce60804290637k21f2465ajed607224a8fe764b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805060021.44095.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com
Subject: Re: video4linux-list Digest, Vol 50, Issue 28
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

Hi Zied,

> I check to run the FM Radio under the Mandriva 2008 Linux
> I have any problem with my Radio that use the v4l and v4l2 librarys.
> this is the driver that I use :
> http://www.linuxhq.com/kernel/v2.6/25-rc8/drivers/media/radio/radio-si470x.c
> and I use the Qt Radio as GUI
> the seeking operations run normally but I have not the RDS (no audio)
> have you any ideas to correcting this problem please.

RDS (Radio Data System) has nothing to do with audio, but can be used f.e. with the rds daemon: http://rdsd.berlios.de/

The device has an USB audio endpoint, which gives you an additional alsa sound device.
You must forward the output from this device to your sound card. That's what I use for it:

arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -

That's because the device has 96k samples/second with 16 bits/sample and 2 channels.

Bye,
  Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
