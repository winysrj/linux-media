Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m32LccQZ020496
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 17:38:38 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.244])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m32LcQjE028795
	for <video4linux-list@redhat.com>; Wed, 2 Apr 2008 17:38:26 -0400
Received: by an-out-0708.google.com with SMTP id c31so796183ana.124
	for <video4linux-list@redhat.com>; Wed, 02 Apr 2008 14:38:26 -0700 (PDT)
Date: Wed, 2 Apr 2008 18:38:20 -0300
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080402183820.6c917a0a@tux.abusar.org.br>
In-Reply-To: <1207093795.16537.4.camel@localhost.localdomain>
References: <20080401190033.68c821ed@tux.abusar.org.br>
	<1207093795.16537.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: Remote controller for Powercolor Real Angel 330
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

On Wed, 02 Apr 2008 03:49:54 +0400
"Nickolay V. Shmyrev" <nshmyrev@yandex.ru> wrote:

> 
> В Втр, 01/04/2008 в 19:00 -0300, Dâniel Fraga пишет:
> > 	The support for Powercolor Real Angel 330 is almost complete.
> > Everything works. I just need to finish the codes for remote controller.
> > 
> > 	I have the following:
> > 
> > 1) cx88-input.c
> > 
> >                 ir_codes = ir_codes_powercolor_real_angel;
> >                 ir->gpio_addr = MO_GP2_IO;
> >                 ir->mask_keycode = 0x7f;
> >                 ir->polling = 1; /* ms */
> > 
> > 2) ir-keymaps.c:
> > 
> >         [0x03] = KEY_1,
> >         [0x05] = KEY_2,
> >         [0x07] = KEY_3,
> >         [0x11] = KEY_8,
> >         [0x13] = KEY_9,
> >         [0x71] = KEY_SWITCHVIDEOMODE,   /* switch inputs */
> >         [0x41] = KEY_UP,
> >         [0x43] = KEY_DOWN,
> >         [0x21] = KEY_RIGHT,
> >         [0x23] = KEY_LEFT,
> >         [0x25] = KEY_PAUSE,
> >         [0x27] = KEY_PLAY,
> >         [0x17] = KEY_STOP,
> >         [0x47] = KEY_FASTFORWARD,
> >         [0x45] = KEY_REWIND,
> >         [0x37] = KEY_RECORD,
> >         [0x35] = KEY_SEARCH,            /* autoscan */
> >         [0x15] = KEY_SHUFFLE,           /* snapshot */
> >         [0x53] = KEY_PREVIOUS,          /* previous channel */
> >         [0x15] = KEY_DIGITS,            /* single, double, tripple digit */ 
> > 	[0x57] = KEY_MODE,              /* stereo/mono */ 
> > 	[0x51] = KEY_TEXT,              /* teletext */  
> > 
> > 	All these keys work perfectly. But some keys use the same code.
> > For example, if I press "5" on the remote, I get "1" and if I press
> > "6", I get "2".
> > 
> > 	***
> > 
> > 	I noticed that some keys generate more than one code... I tried
> > all ir types (RC5, PD, OTHER) without success. Does anybody have any
> > clues about that?
> > 
> > 	Could the mask_keycode be wrong? Any hints?
> > 
> 
> Keymask is wrong most probably. Get the right one with RegSpy
> application from Dscaler project in Windows.

	Hi Nicholas. Thanks for the answer.
	
	I got Regspy running and I can monitor MO_GP2_IO. The problem
is:

1) when I press key "1", MO_GP2_IO changes to 0x883. Then if I press it
again (the same key "1") it changes to 0x803. And it will switch
between 883 and 803 each time I press "1"

2) for key "2" it alternates between 0x885 and 0x805

3) for key "3" it alternates between 0x887 and 0x807

4) for key "4" it alternates between 0x881 and 0x801

5) for key "5" it alternates between 0x883 and 0x803

	What exactly should I look at Regspy? Thank you!


-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
