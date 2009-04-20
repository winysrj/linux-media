Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3KGgCjR016848
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 12:42:12 -0400
Received: from mail-gx0-f158.google.com (mail-gx0-f158.google.com
	[209.85.217.158])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3KGer7D007207
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 12:41:57 -0400
Received: by mail-gx0-f158.google.com with SMTP id 2so1817476gxk.3
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 09:41:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090421023426.b1a37cdf.anthony-v4l@hogan.id.au>
References: <20090420230653.7089115b.anthony-v4l@hogan.id.au>
	<412bdbff0904200632n5c395252s3f27335c575b188f@mail.gmail.com>
	<20090421023426.b1a37cdf.anthony-v4l@hogan.id.au>
Date: Mon, 20 Apr 2009 12:41:57 -0400
Message-ID: <412bdbff0904200941m254f57aep3850374f87ebc413@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Anthony Hogan <anthony-v4l@hogan.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: eMPIA device without unique USB ID or EEPROM..
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

On Mon, Apr 20, 2009 at 12:34 PM, Anthony Hogan <anthony-v4l@hogan.id.au> wrote:
> So is the solution that I need to fiddle perhaps with something similar
> to following:
> ....
>        [EM2860_BOARD_FISSION_DK8703] = {
>                .name         = "Fission DK-8703",
>                .valid        = EM28XX_BOARD_NOT_VALIDATED,
>                .vchannels    = 2,
>                .tuner_type   = TUNER_ABSENT,
>                .decoder      = EM28XX_TVP5150,
>                .input          = { {
>                        .type     = EM28XX_VMUX_COMPOSITE0,
>                        .vmux     = TVP5150_COMPOSITE0,
>                        .amux     = 1,
>                }, {
>                        .type     = EM28XX_VMUX_SVIDEO,
>                        .vmux     = TVP5150_SVIDEO,
>                        .amux     = 1,
>                } },
>        },
> ....
> /* I2C devicelist hash table for devices with generic USB IDs */
> static struct em28xx_hash_table em28xx_i2c_hash[] = {
>        {0x77800080, EM2860_BOARD_FISSION_DK8703, TUNER_ABSENT},
> ....

Yes, you are exactly on the right track.

> Is it possible that the em28xx driver has incorrectly detected a
> TVP5150 decoder? I notice that .../drivers/media/video/tvp5150.c seems
> to suggest that there's always a TV input?
>
>        switch (decoder->route.input) {
>        case TVP5150_COMPOSITE1:
>                input |= 2;
>                /* fall through */
>        case TVP5150_COMPOSITE0:
>                opmode=0x30;            /* TV Mode */
>                break;
>        case TVP5150_SVIDEO:
>        default:
>                input |= 1;
>                opmode=0;               /* Auto Mode */
>                break;
>        }

It's possible that it mis-detected a tvp5150, but it's unlikely.
There aren't many different decoders that were used for those boards
(all the ones I have seen are either tvp5150 or saa711x).  You might
want to check the .vmux field, since it's possible that it's tied to a
different input.

Also, I would suggest you hook up both the s-video and the composite
to valid video sources, so you can test both inputs (this lets you see
if one is working but not the other).

> Am I thinking along the correct lines? Missing something? As I said,
> I'm no C coder, but I'll give stuff a go :)
>

Looks like you're on the right track.  Keep up the good work.

Why don't you compile the code as you describe above, and then open
tvtime, select the composite or s-video output, and then send the full
dmesg output.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
