Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GNFESf017204
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 19:15:14 -0400
Received: from exprod8og107.obsmtp.com (exprod8og107.obsmtp.com [64.18.3.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5GNEMff007338
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 19:14:32 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Date: Mon, 16 Jun 2008 16:12:29 -0700
Message-ID: <1822849CB0478545ADCFB217EF4A34057FED76@sedah.startrac.com>
In-Reply-To: <20080615083447.4d288a9e@gaivota>
References: <48513259.6030003@iinet.net.au> <20080615083447.4d288a9e@gaivota>
From: "Dan Taylor" <dtaylor@startrac.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>, "timf" <timf@iinet.net.au>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: RE: [PATCH] Avermedia A16d Avermedia E506
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

I have S-Video and Composite working on an Avermedia A16D.  It's a small
change to saa7134-cards.c.  The gpiomask (0x04000000) and gpio settings
control the analog mux on the A16D.  The small composite->S-Video
adapter that comes with the board routes composite to S-Video luma, so
the vmux (mode of the saa7134, really) is set to use the same pin, but
as composite.  The composite input has been tested with a signal
generator and iPod (PAL and NTSC) with mplayer.


        [SAA7134_BOARD_AVERMEDIA_A16D] = {
                .name           = "AVerMedia Hybrid TV/Radio (A16D)",
                .audio_clock    = 0x187de7,
                .tuner_type     = TUNER_XC2028,
                .radio_type     = UNSET,
                .tuner_addr     = ADDR_UNSET,
                .radio_addr     = ADDR_UNSET,
                .gpiomask       = 0x04400000,   /* dlt; controls
external vmux; enables DVB */
                .mpeg           = SAA7134_MPEG_DVB, /* dlt; test not
completed */
                .inputs         = {{
                        .name = name_tv,
                        .vmux = 1,
                        .amux = TV,
                        .tv   = 1,
                        .gpio = 0,
                }, {
                        .name = name_svideo,
                        .vmux = 8,
                        .amux = LINE1,
                        .gpio = 0,
                }, {
                        .name = name_comp,
                        .vmux = 0,
                        .amux = LINE1,
                        .gpio = 0,
                } },
                .radio = {
                        .name = name_radio,
                        .amux = LINE1,
                },
        },


-----Original Message-----
From: video4linux-list-bounces@redhat.com
[mailto:video4linux-list-bounces@redhat.com] On Behalf Of Mauro Carvalho
Chehab
Sent: Sunday, June 15, 2008 4:35 AM
To: timf
Cc: video4linux-list@redhat.com; linux-dvb@linuxtv.org
Subject: Re: [PATCH] Avermedia A16d Avermedia E506

On Thu, 12 Jun 2008 22:27:37 +0800
timf <timf@iinet.net.au> wrote:

> 
> Hi Mauro,
> 
> OK, Herewith find the patch for the Avermedia A16d, and the Avermedia 
> E506 Cardbus.
> I am using Thunderbird, so as well as pasting it here I shall attach
it.
> DVB-T, Analog-TV, FM-Radio - work for both cards.
> Composite, S-Video not tested.
> 
> Regards,
> Timf
> 
> Signed-off-by: Tim Farrington <timf@iinet.net.au>
> 

Hi Tim,

Your patch didn't apply:

$ patch -p1 -i /home/v4l/tmp/mailimport23503/patch.diff
patching file linux/drivers/media/common/ir-keymaps.c
Hunk #1 succeeded at 2251 with fuzz 1.
missing header for unified diff at line 898 of patch
patching file linux/drivers/media/video/saa7134/saa7134-cards.c
Hunk #1 FAILED at 4232.
Hunk #2 FAILED at 4259.
Hunk #3 FAILED at 4272.
Hunk #4 FAILED at 5503.
Hunk #5 FAILED at 5727.
Hunk #6 FAILED at 5739.
Hunk #7 FAILED at 5865.
7 out of 7 hunks FAILED -- saving rejects to file
linux/drivers/media/video/saa7134/saa7134-cards.c.rej
patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
Hunk #1 FAILED at 153.
Hunk #2 FAILED at 212.
patch: **** malformed patch at line 1073: &avermedia_xc3028_mt352_dev,

Also, running checkpatch.pl generates lots of codingstyle errors and
warnings.

Please, re-generate it against the latest tree, fix coding style and be
sure
that your emailer is not breaking long lines or replacing tabs with
spaces. If
you're using thunderbird, maybe it would be better to send, instead, as
an
attachment.



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe
mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
