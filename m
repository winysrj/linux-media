Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2ICdr2N002661
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 08:39:53 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2ICdLoL021850
	for <video4linux-list@redhat.com>; Tue, 18 Mar 2008 08:39:21 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Tue, 18 Mar 2008 13:39:12 +0100
References: <200803161131.37966.zzam@gentoo.org>
	<20080318092648.3a517301@gaivota>
In-Reply-To: <20080318092648.3a517301@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200803181339.13040.zzam@gentoo.org>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Peter Meszmer <hubblest@web.de>
Subject: Re: [PATCH] Updated analog only support of Avermedia A700 cards -
	adds RF input support via XC2028 tuner (untested)
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

On Dienstag, 18. März 2008, Mauro Carvalho Chehab wrote:
> On Sun, 16 Mar 2008 11:31:37 +0100
>
> For this to work, you'll need to set xc3028 parameters. This device needs a
> reset during firmware load. This is done via xc3028_callback. To reset, you
> need to turn some GPIO values, and then, return they back to their original
> values. The GPIO's are device dependent. So, you'll need to check with some
> software like Dscaler's regspy.exe what pins are changed during reset.

I can only have a look at the wiring.

>
> Also, there are two ways for audio to work with xc3028/2028: MTS mode and
> non-mts. You'll need to test both ways.
>
> A final notice: most current devices work fine with firmware v2.7. However,
> a few devices only work if you use an older firmware version.
>
> Could you please send us the logs with i2c_scan=1?
>

I do not have that hardware. I only have the A700 without XC2028 soldered on 
it. But maybe Peter can help out on this.

> Please, use the latest version of v4l-dvb, since I did some fixes for cx88
> and saa7134 there recently.
>
I do use latest v4l-dvb tree and create patches on top of this.
As this card is labled Hybrid+FM I should also add a radio section, I guess.

Regards
Matthias

-- 
Matthias Schwarzott (zzam)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
