Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33HjKcb022881
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 13:45:20 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.243])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m33Hj3g4025800
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 13:45:03 -0400
Received: by an-out-0708.google.com with SMTP id c31so912207ana.124
	for <video4linux-list@redhat.com>; Thu, 03 Apr 2008 10:45:03 -0700 (PDT)
Date: Thu, 3 Apr 2008 14:44:56 -0300
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
To: "Nickolay V. Shmyrev" <nshmyrev@yandex.ru>, video4linux-list@redhat.com
Message-ID: <20080403144456.1e6bf438@tux.abusar.org.br>
In-Reply-To: <1207204144.2386.1.camel@localhost.localdomain>
References: <20080401190033.68c821ed@tux.abusar.org.br>
	<1207093795.16537.4.camel@localhost.localdomain>
	<20080402183820.6c917a0a@tux.abusar.org.br>
	<1207204144.2386.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: 
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

On Thu, 03 Apr 2008 10:29:04 +0400
"Nickolay V. Shmyrev" <nshmyrev@yandex.ru> wrote:

> 
> В Срд, 02/04/2008 в 18:38 -0300, Dâniel Fraga пишет:
> > On Wed, 02 Apr 2008 03:49:54 +0400
> > "Nickolay V. Shmyrev" <nshmyrev@yandex.ru> wrote:
> > 
> > > 
> > > В Втр, 01/04/2008 в 19:00 -0300, Dâniel Fraga пишет:
> > > > 	The support for Powercolor Real Angel 330 is almost complete.
> > > > Everything works. I just need to finish the codes for remote controller.
> > > > 
> > > > 	I have the following:
> > > > 
> > > > 1) cx88-input.c
> > > > 
> > > >                 ir_codes = ir_codes_powercolor_real_angel;
> > > >                 ir->gpio_addr = MO_GP2_IO;
> > > >                 ir->mask_keycode = 0x7f;
> > > >                 ir->polling = 1; /* ms */
> > > > 
> > > > 2) ir-keymaps.c:
> > > > 
> > > >         [0x03] = KEY_1,
> > > >         [0x05] = KEY_2,
> > > >         [0x07] = KEY_3,
> > > >         [0x11] = KEY_8,
> > > >         [0x13] = KEY_9,
> > > >         [0x71] = KEY_SWITCHVIDEOMODE,   /* switch inputs */
> > > >         [0x41] = KEY_UP,
> > > >         [0x43] = KEY_DOWN,
> > > >         [0x21] = KEY_RIGHT,
> > > >         [0x23] = KEY_LEFT,
> > > >         [0x25] = KEY_PAUSE,
> > > >         [0x27] = KEY_PLAY,
> > > >         [0x17] = KEY_STOP,
> > > >         [0x47] = KEY_FASTFORWARD,
> > > >         [0x45] = KEY_REWIND,
> > > >         [0x37] = KEY_RECORD,
> > > >         [0x35] = KEY_SEARCH,            /* autoscan */
> > > >         [0x15] = KEY_SHUFFLE,           /* snapshot */
> > > >         [0x53] = KEY_PREVIOUS,          /* previous channel */
> > > >         [0x15] = KEY_DIGITS,            /* single, double, tripple digit */ 
> > > > 	[0x57] = KEY_MODE,              /* stereo/mono */ 
> > > > 	[0x51] = KEY_TEXT,              /* teletext */  
> > > > 
> > > > 	All these keys work perfectly. But some keys use the same code.
> > > > For example, if I press "5" on the remote, I get "1" and if I press
> > > > "6", I get "2".
> > > > 
> > > > 	***
> > > > 
> > > > 	I noticed that some keys generate more than one code... I tried
> > > > all ir types (RC5, PD, OTHER) without success. Does anybody have any
> > > > clues about that?
> > > > 
> > > > 	Could the mask_keycode be wrong? Any hints?
> > > > 
> > > 
> > > Keymask is wrong most probably. Get the right one with RegSpy
> > > application from Dscaler project in Windows.
> > 
> > 	Hi Nicholas. Thanks for the answer.
> > 	
> > 	I got Regspy running and I can monitor MO_GP2_IO. The problem
> > is:
> > 
> > 1) when I press key "1", MO_GP2_IO changes to 0x883. Then if I press it
> > again (the same key "1") it changes to 0x803. And it will switch
> > between 883 and 803 each time I press "1"
> > 
> > 2) for key "2" it alternates between 0x885 and 0x805
> > 
> > 3) for key "3" it alternates between 0x887 and 0x807
> > 
> > 4) for key "4" it alternates between 0x881 and 0x801
> > 
> > 5) for key "5" it alternates between 0x883 and 0x803
> > 
> > 	What exactly should I look at Regspy? Thank you!
> 
> Hm, looks strange. Probably something else is not powered properly. Did
> you check your initial mask and gpio? Could you just share regspy output
> and give us a link? Also please show use the changes you've made to add
> your card support.
> 

1) how can i check the initial mask and gpio? From regspy?

2) regspy output:

http://img201.imageshack.us/my.php?image=regspyed9.gif

	You can notice that MO_GP2_IO is what changes when I press a
key. But for every press, it change values according my previous
message.

3) the changes already merged in the v4l-dvb tree are:

********************* cx88-cards.c ***********************

        [CX88_BOARD_POWERCOLOR_REAL_ANGEL] = {
                .name           = "PowerColor Real Angel 330",
                .tuner_type     = TUNER_XC2028,
                .tuner_addr     = 0x61,
                .input          = { {
                        .type   = CX88_VMUX_TELEVISION,
                        .vmux   = 0,
                        .gpio0 = 0x0400, /* pin 2:mute = 0 (off?) */
                        .gpio1 = 0xf35d,
                        .gpio2 = 0x0800, /* pin 19:audio = 0 (tv) */
                }, {
                        .type   = CX88_VMUX_COMPOSITE1,
                        .vmux   = 1,
                        .gpio0 = 0x0400, /* probably?  or 0x0404 to turn mute on */ .gpio1 = 0x0000,
                        .gpio2 = 0x0808, /* pin 19:audio = 1 (line) */
                }, {
                        .type   = CX88_VMUX_SVIDEO,
                        .vmux   = 2,
                        .gpio0  = 0x000ff,
                        .gpio1  = 0x0f37d,
                        .gpio2  = 0x00019,
                        .gpio3  = 0x00000,
                } },
                .radio = {
                        .type   = CX88_RADIO,
                        .gpio0  = 0x000ff,
                        .gpio1  = 0x0f35d,
                        .gpio2  = 0x00019,
                        .gpio3  = 0x00000,
                },
        },

	This need to be merged (but I need to finish the key codes first ;)

******************* cx88-input.c *************************

        case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
                ir_codes = ir_codes_powercolor_real_angel;
                ir->gpio_addr = MO_GP2_IO;
                ir->mask_keycode = 0x7f;
                ir->polling = 1; /* ms */
                break;

****************** ir-keymaps.c **************************

IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE] = {
        /* Keys 0 to 9 */
        [0x03] = KEY_1,
        [0x05] = KEY_2,
        [0x07] = KEY_3,
        [0x11] = KEY_8,
        [0x13] = KEY_9,
        [0x71] = KEY_SWITCHVIDEOMODE,   /* switch inputs */
        [0x41] = KEY_UP,
        [0x43] = KEY_DOWN,
        [0x21] = KEY_RIGHT,
        [0x23] = KEY_LEFT,
        [0x25] = KEY_PAUSE,
        [0x27] = KEY_PLAY,
        [0x17] = KEY_STOP,
        [0x47] = KEY_FASTFORWARD,
        [0x45] = KEY_REWIND,
        [0x37] = KEY_RECORD,
        [0x35] = KEY_SEARCH,            /* autoscan */
        [0x15] = KEY_SHUFFLE,           /* snapshot */
        [0x53] = KEY_PREVIOUS,          /* previous channel */
        [0x15] = KEY_DIGITS,            /* single, double, tripple digit */
        [0x57] = KEY_MODE,                      /* stereo/mono */
        [0x51] = KEY_TEXT,                      /* teletext */  
};
EXPORT_SYMBOL_GPL(ir_codes_powercolor_real_angel);

********************** ir-common.c *****************************

extern IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE];

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
