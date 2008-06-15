Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FCU4eu010997
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 08:30:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FCTqSB006914
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 08:29:52 -0400
Date: Sun, 15 Jun 2008 09:29:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080615092942.312627a1@gaivota>
In-Reply-To: <4855085A.8070002@iinet.net.au>
References: <48513259.6030003@iinet.net.au> <20080615083447.4d288a9e@gaivota>
	<4855044D.7000702@iinet.net.au> <4855085A.8070002@iinet.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [PATCH] Avermedia A16d Avermedia E506
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

On Sun, 15 Jun 2008 20:17:30 +0800
timf <timf@iinet.net.au> wrote:

> timf wrote:
> > Mauro Carvalho Chehab wrote:
> >> On Thu, 12 Jun 2008 22:27:37 +0800
> >> timf <timf@iinet.net.au> wrote:
> >>
> >>  
> >>> Hi Mauro,
> >>>
> >>> OK, Herewith find the patch for the Avermedia A16d, and the 
> >>> Avermedia E506 Cardbus.
> >>> I am using Thunderbird, so as well as pasting it here I shall attach 
> >>> it.
> >>> DVB-T, Analog-TV, FM-Radio - work for both cards.
> >>> Composite, S-Video not tested.
> >>>
> >>> Regards,
> >>> Timf
> >>>
> >>> Signed-off-by: Tim Farrington <timf@iinet.net.au>
> >>>
> >>>     
> >>
> >> Hi Tim,
> >>
> >> Your patch didn't apply:
> >>
> >> $ patch -p1 -i /home/v4l/tmp/mailimport23503/patch.diff
> >> patching file linux/drivers/media/common/ir-keymaps.c
> >> Hunk #1 succeeded at 2251 with fuzz 1.
> >> missing header for unified diff at line 898 of patch
> >> patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> >> Hunk #1 FAILED at 4232.
> >> Hunk #2 FAILED at 4259.
> >> Hunk #3 FAILED at 4272.
> >> Hunk #4 FAILED at 5503.
> >> Hunk #5 FAILED at 5727.
> >> Hunk #6 FAILED at 5739.
> >> Hunk #7 FAILED at 5865.
> >> 7 out of 7 hunks FAILED -- saving rejects to file 
> >> linux/drivers/media/video/saa7134/saa7134-cards.c.rej
> >> patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> >> Hunk #1 FAILED at 153.
> >> Hunk #2 FAILED at 212.
> >> patch: **** malformed patch at line 1073: &avermedia_xc3028_mt352_dev,
> >>
> >> Also, running checkpatch.pl generates lots of codingstyle errors and 
> >> warnings.
> >>
> >> Please, re-generate it against the latest tree, fix coding style and 
> >> be sure
> >> that your emailer is not breaking long lines or replacing tabs with 
> >> spaces. If
> >> you're using thunderbird, maybe it would be better to send, instead, 
> >> as an
> >> attachment.
> >>
> >>
> >>
> >> Cheers,
> >> Mauro
> >>
> >>   
> > Hi Mauro,
> > I'm a lttle confused.
> > I simply cloned via hg into a directory.
> > I copied that v4l-dvb as v4l-dvb-a16d-e506.
> > I then modified v4l-dvb-a16d-e506 with my mods.
> > I then did: diff -upr v4l-dvb v4l-dvb-a16d-e506r
> > I made a 2nd copy of v4l-dvb in another directory.
> > In that 2nd directory I did: patch -p0 < v4l-dvb-a16d-e506.diff
> > I had no errors.
> > I then did diff -upr ../v4l-dvb v4l-dvb-a16d-e506
> > which produced no differences.
> > I applied checkpatch.pl with no errors.
> > I then emailed you the v4l-dvb-a16d-e506.diff file as an attachment.
> >
> >
> > I have tried using hg diff ...
> > but it bails out with a message about mine not being a mercurial 
> > depository.
> >
> > Did you check with the attachment? as I said in the email that I was 
> > using Thunderbird.
> >
> > When I produced the patch, it was against the then current mercurial, 
> > 3 days ago.
> >
> > Regards,
> > Tim Farrington
> >
> > -- 
> > video4linux-list mailing list
> > Unsubscribe 
> > mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
> I just downloaded latest hg
> Then tried patch.
> result at command line:
> timf@ubuntu:~/1/try1$ patch -p0 < v4l-dvb-a16d-e506.diff
> patching file v4l-dvb/linux/drivers/media/common/ir-keymaps.c
> patching file v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
> Hunk #7 succeeded at 5866 (offset 1 line).
> patching file v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
> Hunk #4 succeeded at 1254 (offset 1 line).
> patching file v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c
> patching file v4l-dvb/linux/include/media/ir-common.h
> timf@ubuntu:~/1/try1$
> 
> I will attach diff file again

Much better. Probably, Thunderbird broke your patch.

Yet, there are lots of checkpacth complains [1]. Could you please fix they and
re-send it to us?

[1] if you've got the tree with "hg clone http://linuxtv.org/hg/v4l-dvb", you
can just do "make checkpatch" to get those errors.

linux/drivers/media/common/ir-keymaps.c: In '	[ 0x20 ] = KEY_LIST,':
linux/drivers/media/common/ir-keymaps.c:2256: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x20 ] = KEY_LIST,':
linux/drivers/media/common/ir-keymaps.c:2256: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x00 ] = KEY_POWER,':
linux/drivers/media/common/ir-keymaps.c:2257: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x00 ] = KEY_POWER,':
linux/drivers/media/common/ir-keymaps.c:2257: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x28 ] = KEY_1,':
linux/drivers/media/common/ir-keymaps.c:2258: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x28 ] = KEY_1,':
linux/drivers/media/common/ir-keymaps.c:2258: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x18 ] = KEY_2,':
linux/drivers/media/common/ir-keymaps.c:2259: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x18 ] = KEY_2,':
linux/drivers/media/common/ir-keymaps.c:2259: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x38 ] = KEY_3,':
linux/drivers/media/common/ir-keymaps.c:2260: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x38 ] = KEY_3,':
linux/drivers/media/common/ir-keymaps.c:2260: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x24 ] = KEY_4,':
linux/drivers/media/common/ir-keymaps.c:2261: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x24 ] = KEY_4,':
linux/drivers/media/common/ir-keymaps.c:2261: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x14 ] = KEY_5,':
linux/drivers/media/common/ir-keymaps.c:2262: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x14 ] = KEY_5,':
linux/drivers/media/common/ir-keymaps.c:2262: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x34 ] = KEY_6,':
linux/drivers/media/common/ir-keymaps.c:2263: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x34 ] = KEY_6,':
linux/drivers/media/common/ir-keymaps.c:2263: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2c ] = KEY_7,':
linux/drivers/media/common/ir-keymaps.c:2264: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2c ] = KEY_7,':
linux/drivers/media/common/ir-keymaps.c:2264: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1c ] = KEY_8,':
linux/drivers/media/common/ir-keymaps.c:2265: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1c ] = KEY_8,':
linux/drivers/media/common/ir-keymaps.c:2265: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3c ] = KEY_9,':
linux/drivers/media/common/ir-keymaps.c:2266: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3c ] = KEY_9,':
linux/drivers/media/common/ir-keymaps.c:2266: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x12 ] = KEY_SUBTITLE,':
linux/drivers/media/common/ir-keymaps.c:2267: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x12 ] = KEY_SUBTITLE,':
linux/drivers/media/common/ir-keymaps.c:2267: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x22 ] = KEY_0,':
linux/drivers/media/common/ir-keymaps.c:2268: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x22 ] = KEY_0,':
linux/drivers/media/common/ir-keymaps.c:2268: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x32 ] = KEY_REWIND,':
linux/drivers/media/common/ir-keymaps.c:2269: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x32 ] = KEY_REWIND,':
linux/drivers/media/common/ir-keymaps.c:2269: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3a ] = KEY_SHUFFLE,':
linux/drivers/media/common/ir-keymaps.c:2270: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3a ] = KEY_SHUFFLE,':
linux/drivers/media/common/ir-keymaps.c:2270: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x02 ] = KEY_PRINT,':
linux/drivers/media/common/ir-keymaps.c:2271: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x02 ] = KEY_PRINT,':
linux/drivers/media/common/ir-keymaps.c:2271: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x11 ] = KEY_CHANNELDOWN,':
linux/drivers/media/common/ir-keymaps.c:2272: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x11 ] = KEY_CHANNELDOWN,':
linux/drivers/media/common/ir-keymaps.c:2272: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x31 ] = KEY_CHANNELUP,':
linux/drivers/media/common/ir-keymaps.c:2273: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x31 ] = KEY_CHANNELUP,':
linux/drivers/media/common/ir-keymaps.c:2273: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0c ] = KEY_ZOOM,':
linux/drivers/media/common/ir-keymaps.c:2274: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0c ] = KEY_ZOOM,':
linux/drivers/media/common/ir-keymaps.c:2274: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1e ] = KEY_VOLUMEDOWN,':
linux/drivers/media/common/ir-keymaps.c:2275: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x1e ] = KEY_VOLUMEDOWN,':
linux/drivers/media/common/ir-keymaps.c:2275: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3e ] = KEY_VOLUMEUP,':
linux/drivers/media/common/ir-keymaps.c:2276: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x3e ] = KEY_VOLUMEUP,':
linux/drivers/media/common/ir-keymaps.c:2276: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0a ] = KEY_MUTE,':
linux/drivers/media/common/ir-keymaps.c:2277: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0a ] = KEY_MUTE,':
linux/drivers/media/common/ir-keymaps.c:2277: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x04 ] = KEY_AUDIO,':
linux/drivers/media/common/ir-keymaps.c:2278: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x04 ] = KEY_AUDIO,':
linux/drivers/media/common/ir-keymaps.c:2278: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x26 ] = KEY_RECORD,':
linux/drivers/media/common/ir-keymaps.c:2279: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x26 ] = KEY_RECORD,':
linux/drivers/media/common/ir-keymaps.c:2279: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x06 ] = KEY_PLAY,':
linux/drivers/media/common/ir-keymaps.c:2280: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x06 ] = KEY_PLAY,':
linux/drivers/media/common/ir-keymaps.c:2280: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x36 ] = KEY_STOP,':
linux/drivers/media/common/ir-keymaps.c:2281: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x36 ] = KEY_STOP,':
linux/drivers/media/common/ir-keymaps.c:2281: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x16 ] = KEY_PAUSE,':
linux/drivers/media/common/ir-keymaps.c:2282: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x16 ] = KEY_PAUSE,':
linux/drivers/media/common/ir-keymaps.c:2282: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2e ] = KEY_REWIND,':
linux/drivers/media/common/ir-keymaps.c:2283: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2e ] = KEY_REWIND,':
linux/drivers/media/common/ir-keymaps.c:2283: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0e ] = KEY_FASTFORWARD,':
linux/drivers/media/common/ir-keymaps.c:2284: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x0e ] = KEY_FASTFORWARD,':
linux/drivers/media/common/ir-keymaps.c:2284: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x30 ] = KEY_TEXT,':
linux/drivers/media/common/ir-keymaps.c:2285: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x30 ] = KEY_TEXT,':
linux/drivers/media/common/ir-keymaps.c:2285: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x21 ] = KEY_GREEN,':
linux/drivers/media/common/ir-keymaps.c:2286: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x21 ] = KEY_GREEN,':
linux/drivers/media/common/ir-keymaps.c:2286: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x01 ] = KEY_BLUE,':
linux/drivers/media/common/ir-keymaps.c:2287: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x01 ] = KEY_BLUE,':
linux/drivers/media/common/ir-keymaps.c:2287: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x08 ] = KEY_EPG,':
linux/drivers/media/common/ir-keymaps.c:2288: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x08 ] = KEY_EPG,':
linux/drivers/media/common/ir-keymaps.c:2288: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2a ] = KEY_MENU,':
linux/drivers/media/common/ir-keymaps.c:2289: ERROR: space prohibited after that open square bracket '['
linux/drivers/media/common/ir-keymaps.c: In '	[ 0x2a ] = KEY_MENU,':
linux/drivers/media/common/ir-keymaps.c:2289: ERROR: space prohibited before that close square bracket ']'
linux/drivers/media/common/ir-keymaps.c: In 'EXPORT_SYMBOL_GPL(ir_codes_avermedia_a16d);':
linux/drivers/media/common/ir-keymaps.c:2292: warning: EXPORT_SYMBOL(foo); should immediately follow its function/variable
linux/drivers/media/video/saa7134/saa7134-cards.c: In '^I^Icase SAA7134_BOARD_AVERMEDIA_A16D:^I$':
linux/drivers/media/video/saa7134/saa7134-cards.c:5514: ERROR: trailing whitespace
linux/drivers/media/video/saa7134/saa7134-cards.c: In '  ^I        dev->has_remote = SAA7134_REMOTE_GPIO;^I^I$':
linux/drivers/media/video/saa7134/saa7134-cards.c:5752: ERROR: trailing whitespace
linux/drivers/media/video/saa7134/saa7134-cards.c: In '  ^I        dev->has_remote = SAA7134_REMOTE_GPIO;^I^I$':
linux/drivers/media/video/saa7134/saa7134-cards.c:5752: ERROR: code indent should use tabs where possible
linux/drivers/media/video/saa7134/saa7134-dvb.c: In '^I$':
linux/drivers/media/video/saa7134/saa7134-dvb.c:163: ERROR: trailing whitespace
linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach, &avermedia_xc3028_mt352_dev,':
linux/drivers/media/video/saa7134/saa7134-dvb.c:972: warning: line over 80 characters
linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach,&avermedia_xc3028_mt352_dev,':
linux/drivers/media/video/saa7134/saa7134-dvb.c:1261: warning: line over 80 characters
linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach,&avermedia_xc3028_mt352_dev,':
linux/drivers/media/video/saa7134/saa7134-dvb.c:1261: ERROR: space required after that ',' (ctx:VxO)
linux/drivers/media/video/saa7134/saa7134-dvb.c: In '		dev->dvb.frontend = dvb_attach(mt352_attach,&avermedia_xc3028_mt352_dev,':
linux/drivers/media/video/saa7134/saa7134-dvb.c:1261: ERROR: space required before that '&' (ctx:OxV)
linux/drivers/media/video/saa7134/saa7134-input.c: In '		polling      = 50; // ms':
linux/drivers/media/video/saa7134/saa7134-input.c:330: ERROR: do not use C99 // comments


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
