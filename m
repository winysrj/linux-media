Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1L0qcTE007280
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 19:52:38 -0500
Received: from n8a.bullet.mail.re3.yahoo.com (n8a.bullet.mail.re3.yahoo.com
	[68.142.236.46])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1L0q2n9007535
	for <video4linux-list@redhat.com>; Wed, 20 Feb 2008 19:52:02 -0500
Date: Wed, 20 Feb 2008 18:51:56 -0600 (CST)
From: Jose Andres Suarez <andrestepeite@yahoo.com.mx>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Message-ID: <95404.14507.qm@web57406.mail.re1.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Support for a new TV card
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

Hi, I bought a TV card without an eeprom, wrote this for saa7134-cards.c:

    [SAA7134_BOARD_ZOGIS_REALANGEL220] = {
        .name           = "ZOGIS REAL ANGEL 220",
        .audio_clock    = 0x00187de7,
        .tuner_type     = TUNER_PHILIPS_NTSC,
        .radio_type     = UNSET,
        .tuner_addr    = ADDR_UNSET,
        .radio_addr    = ADDR_UNSET,
        .inputs         = {{
            .name = name_svideo,
            .vmux = 8,
            .amux = LINE1,
        },{
            .name = name_comp1,
            .vmux = 1,
            .amux = LINE1,
        },{
            .name = name_tv,
            .vmux = 3,
            .amux = LINE2,
            .tv   = 1,
        }},
    },

and for  saa7134.h:

#define SAA7134_BOARD_ZOGIS_REALANGEL220   136

All inputs works fine, can anyone please add that to the V2L source? I am missing something?

PD. lspci results are:
01:07.0 0480: 1131:7130 (rev 01)
        Subsystem: 1131:0000
        Flags: bus master, medium devsel, latency 32, IRQ 17
        Memory at fb010000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1


01:07.0 Multimedia controller: Philips Semiconductors SAA7130 Video Broadcast Decoder (rev 01)
        Subsystem: Philips Semiconductors Unknown device 0000
        Flags: bus master, medium devsel, latency 32, IRQ 17
        Memory at fb010000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1


       
---------------------------------

¡Capacidad ilimitada de almacenamiento en tu correo!
No te preocupes más por el espacio de tu cuenta con Correo Yahoo!:
http://correo.yahoo.com.mx/
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
