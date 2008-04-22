Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MGMCF7021506
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 12:22:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MGLxjg017447
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 12:21:59 -0400
Date: Tue, 22 Apr 2008 13:21:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Edward J. Sheldrake" <ejs1920@yahoo.co.uk>
Message-ID: <20080422132139.1e8e5f4a@gaivota>
In-Reply-To: <564195.23707.qm@web27904.mail.ukl.yahoo.com>
References: <564195.23707.qm@web27904.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: em28xx/xc3028: changeset 7651 breaks analog audio?
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

Hi Edward,

On Tue, 22 Apr 2008 16:38:32 +0100 (BST)
"Edward J. Sheldrake" <ejs1920@yahoo.co.uk> wrote:

> Hello
> 
> I have a Hauppauge HVR-900 rev B3C0, and until very recently it was
> working fine with the em28xx driver in the main v4l-dvb repository. I
> live in England, so have set the option pal=i for the tuner module. It
> was working fine with with the repository from 20080420. I'm watching
> analog TV.
> 
> However, with the repository from 20080422, I just get static from the
> audio output. None of the audio_std options for the tuner_xc2028 module
> made any difference. The only changeset I could see for the modules I
> use is 7651, about the firmware for the xc3028 tuner.

Thanks for your report.

There were lots of changes on em28xx driver those days, although I agree that
the only one that would affect just audio is the one you've pointed. If you
just revert this changeset, does the audio work again?

> 
> Here's relevant dmesg output for the older working driver:
> http://pastebin.com/f399535d5
> 
> And here's the same with the non-working driver:
> http://pastebin.com/fdd8e82e

This is probably wrong:

xc2028 1-0061: Loading SCODE for type=SCODE HAS_IF_6240 (60000000), id 0000000000000010.

The proper SCODE firmware for your device seems to be this one:

Firmware 69, type: SCODE FW  MONO HAS IF (0x60008000), IF = 6.00 MHz id: PAL/DK PAL/I SECAM/K3 SECAM/L SECAM/Lc NICAM (0000000c04c000f0), size: 192

or, since your board is using a MTS firmware, maybe we shouldn't load any SCODE table.

I'll run some tests here. Please confirm that just reverting that changeset will work fine again.

To revert, all you need is to do:
	hg log -r 7651 -v -p >7651.patch
	patch -p1 -R -i 7651.patch

and compile the tree again.

If this won't work, you may also do:
	hg update -r 7650

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
