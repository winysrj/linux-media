Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n27NRv3O021121
	for <video4linux-list@redhat.com>; Sat, 7 Mar 2009 18:27:57 -0500
Received: from mail-in-11.arcor-online.net (mail-in-11.arcor-online.net
	[151.189.21.51])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n27NRZoc028099
	for <video4linux-list@redhat.com>; Sat, 7 Mar 2009 18:27:36 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: rahul G <freevofc6@gmail.com>
In-Reply-To: <ca1417c50903060547l7cedda32q8795dc5a40b896dd@mail.gmail.com>
References: <ca1417c50903060547l7cedda32q8795dc5a40b896dd@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 00:28:59 +0100
Message-Id: <1236468539.2203.16.camel@pc09.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Problem with the TV out Sound !!!
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

Hi,

Am Freitag, den 06.03.2009, 19:17 +0530 schrieb rahul G:
>  Hi All....
>             I am using Pinnacle 50i TV tuner card for watching TV but
> Radio functionality is not working with the card when I used
> "/sbin/modprobe saa7134 card=77 tuner=54".
> TV is working fine with this on linux-2.26.23.3.But when I used
> "/sbin/modprobe saa7134 card=65 tuner=54" my radio is working fine
> with this tuner card and not  TV.
> When I tried with Linux-2.26.23.1 kernel with same command
> "/sbin/modprobe saa7134 card=77 tuner=54" radio is working fine but
> sound coming out from the device is too small.which not audiable.Can
> any one tell me the reason behind this.
> 
> Thanks In Advance..
> 
> Regards,
> Rahul G
> 

hmm, on my 2.6.26 sources radio settings for card=65 and card=77 are
exactly the same. Please confirm about which kernel versions you are
talking. I know radio was not functional on card=77 and older kernels.

	[SAA7134_BOARD_PINNACLE_PCTV_110i] = {
	       .name           = "Pinnacle PCTV 40i/50i/110i (saa7133)",
		.audio_clock    = 0x00187de7,
		.tuner_type     = TUNER_PHILIPS_TDA8290,
		.radio_type     = UNSET,
		.tuner_addr     = ADDR_UNSET,
		.radio_addr     = ADDR_UNSET,
		.gpiomask       = 0x080200000,
		.inputs         = { {
			.name = name_tv,
			.vmux = 4,
			.amux = TV,
			.tv   = 1,
		}, {
			.name = name_comp1,
			.vmux = 1,
			.amux = LINE2,
		}, {
			.name = name_comp2,
			.vmux = 0,
			.amux = LINE2,
		}, {
			.name = name_svideo,
			.vmux = 8,
			.amux = LINE2,
		} },
		.radio = {
			.name = name_radio,
			.amux = TV,
			.gpio = 0x0200000,
		},
	},

----

	[SAA7134_BOARD_KWORLD_TERMINATOR] = {
		/* Kworld V-Stream Studio TV Terminator */
		/* "James Webb <jrwebb@qwest.net> */
		.name           = "V-Stream Studio TV Terminator",
		.audio_clock    = 0x00187de7,
		.tuner_type     = TUNER_PHILIPS_TDA8290,
		.radio_type     = UNSET,
		.tuner_addr     = ADDR_UNSET,
		.radio_addr     = ADDR_UNSET,
		.gpiomask       = 1 << 21,
		.inputs         = {{
			.name = name_tv,
			.vmux = 1,
			.amux = TV,
			.gpio = 0x0000000,
			.tv   = 1,
		},{
			.name = name_comp1,     /* Composite input */
			.vmux = 3,
			.amux = LINE2,
			.gpio = 0x0000000,
		},{
			.name = name_svideo,    /* S-Video input */
			.vmux = 8,
			.amux = LINE2,
			.gpio = 0x0000000,
		}},
		.radio = {
			.name = name_radio,
			.amux = TV,
			.gpio = 0x0200000,
		},
	},

Ricardo only used a gpio mask extended to four bytes and the last bit
high, what is seen regularly on the windows drivers.

However, it doesn't matter, since the chip has only 28 gpio pins (0-27).

Does it really makes still a difference if you use radio now on 2.6.26
with card=65 ?

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
