Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8E2dWoD025486
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 22:39:33 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8E2d7C2015474
	for <video4linux-list@redhat.com>; Sat, 13 Sep 2008 22:39:19 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, v4ldvb@linuxtv.org,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
In-Reply-To: <20080911103801.52629349@mchehab.chehab.org>
References: <48C4FC1F.40509@comcast.net>
	<20080911103801.52629349@mchehab.chehab.org>
Content-Type: text/plain
Date: Sun, 14 Sep 2008 04:35:19 +0200
Message-Id: <1221359719.6598.31.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Henry Wong <henry@stuffedcow.net>,
	Schultz <n9xmj@yahoo.com>
Subject: Re: [PATCH] Add support for MSI TV@nywhere Plus remote
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

Am Donnerstag, den 11.09.2008, 10:38 -0300 schrieb Mauro Carvalho
Chehab:
> Hi Brian,
> 
> On Mon, 08 Sep 2008 03:19:11 -0700
> Brian Rogers <brian_rogers@comcast.net> wrote:
> 
> > I've been carrying this patch, originally by Henry Wong, for a while. 
> > Here's the latest version, based off the linux master branch. I think 
> > it's ready for inclusion.
> > 
> > Rather than going on a probing spree, as in the previous version, I just 
> > probe a single address that's known to respond (0x50) as the workaround 
> > for the controller quirk. Also, the polling interval is no longer 
> > handled globally.
> 
> 
> The patch looks good. However, it has two issues:
> 	1) Your emailer corrupted it, by replacing tabs by spaces, and wrapping
> lines. So, the patch doesn't apply:
> 
> $ patch -p1 -i /tmp/patches --dry-run -d linux
> patching file drivers/media/common/ir-keymaps.c
> patch: **** malformed patch at line 68:      [ 0x00 ] = KEY_0,
> 
> 	2) There are a number of coding style violations. The main points are:
> 
> - Use tabs instead of spaces to indent (I suspect that this trouble happens due
> to your emailer). A tab corresponds to 8 columns at kernel;
> 
> - don't use spaces between brackets. So, newer IR tables should be:
> 	[0x1d] = KEY_foo;
> 
> - Use lower case for hexadecimal values (instead of 0x1D, prefer to use 0x1d);
> 
> - Use space after comma;
> 
> - Avoid using lines with more than 80 cols.
> 
> The better is to check your patch against the checkpatch.pl script (at kernel
> tree and at v4l/scripts/checkpatch.pl). If you have a tree cloned from hg, the
> easiest way is to apply your patch at the tree and use "make checkpatch" before
> committing it).
> 
> Side note: Yes, I know that there are a large amount of style violations at the
> current drivers. The idea is trying to avoid adding even more ;)
> 
> Cheers,
> Mauro


Mauro,

this is the oldest and most important outstanding patch we have.

There are whole generations of cards still without of any IR support,
since years, because of that.

If this one should still hang on coding style violations, please let me
know.

If you would ever find time again, have a look at my patch enabling
first support for the new Asus Tiger 3in1, which I have only as an OEM
board, but which is coming up to global distribution now and likely will
cover all newer boards.

I'm still not related to them and never asked a single question.

But with the OEM version we likely have support for both new variants
too. As previously, I can't confirm for the IR on that OEM, but guess
previous work was not in vain!

All previous is correct, but the composite input on vmux 3 does not
exist and we don't need any other gpio21 switch, except for radio.

I wasted some time again, to fit into the 80 columns rule on
saaa7134-dvb.c, and all I can say is, this way not with me.

Please exercise it yourself now, you have all relevant information, show
the resulting code and explain, why such crap should be looking good.

BTW, editors can break down lines, if needed, since close to ever, and
mark it even for the blindest.

Cheers,
Hermann











 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
