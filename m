Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m31MTCXr016448
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:29:12 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m31MSpC1008997
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 18:28:52 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JgoyI-0006EO-GO
	for video4linux-list@redhat.com; Tue, 01 Apr 2008 22:28:50 +0000
Received: from c9346dce.virtua.com.br ([201.52.109.206])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 22:28:50 +0000
Received: from fragabr by c9346dce.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 22:28:50 +0000
To: video4linux-list@redhat.com
From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Date: Tue, 1 Apr 2008 19:00:33 -0300
Message-ID: <20080401190033.68c821ed@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Remote controller for Powercolor Real Angel 330
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

	The support for Powercolor Real Angel 330 is almost complete.
Everything works. I just need to finish the codes for remote controller.

	I have the following:

1) cx88-input.c

                ir_codes = ir_codes_powercolor_real_angel;
                ir->gpio_addr = MO_GP2_IO;
                ir->mask_keycode = 0x7f;
                ir->polling = 1; /* ms */

2) ir-keymaps.c:

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
	[0x57] = KEY_MODE,              /* stereo/mono */ 
	[0x51] = KEY_TEXT,              /* teletext */  

	All these keys work perfectly. But some keys use the same code.
For example, if I press "5" on the remote, I get "1" and if I press
"6", I get "2".

	***

	I noticed that some keys generate more than one code... I tried
all ir types (RC5, PD, OTHER) without success. Does anybody have any
clues about that?

	Could the mask_keycode be wrong? Any hints?

-- 
Linux 2.6.24: Arr Matey! A Hairy Bilge Rat!
http://u-br.net http://www.abusar.org/FELIZ_2008.html


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
