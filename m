Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3KGYjfP010902
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 12:34:45 -0400
Received: from hosted02.westnet.com.au (hosted02.westnet.com.au [203.10.1.213])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3KGYTCD003436
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 12:34:30 -0400
Date: Tue, 21 Apr 2009 02:34:26 +1000
From: Anthony Hogan <anthony-v4l@hogan.id.au>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Message-Id: <20090421023426.b1a37cdf.anthony-v4l@hogan.id.au>
In-Reply-To: <412bdbff0904200632n5c395252s3f27335c575b188f@mail.gmail.com>
References: <20090420230653.7089115b.anthony-v4l@hogan.id.au>
	<412bdbff0904200632n5c395252s3f27335c575b188f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

> > em28xx #0: Board i2c devicelist hash is 0x77800080
...
> In cases like this, you typically make use of the i2c hash.  Create an
> entry in the list of devices using i2c hashes (using 0x77800080 as the
> value based on your dmesg output), and then just create a regular
> device profile.

Whilst I compile my kernel from source, I'm not exactly the world's
most experienced programmer :). My thoughts are you're talking about
adding additional code
to .../drivers/media/video/em28xx/em28xx-cards.c that might better
represent what I know about my device.

Looking at the source file, I notice that every known device that's
detailed that uses a TVP5150 video decoder has a television input. My
device doesn't - it only has composite and SVHS... but the em28xx
driver does an i2c scan and finds a TVP5150.

So is the solution that I need to fiddle perhaps with something similar
to following:
....
        [EM2860_BOARD_FISSION_DK8703] = {
                .name         = "Fission DK-8703",
                .valid        = EM28XX_BOARD_NOT_VALIDATED,
                .vchannels    = 2,
                .tuner_type   = TUNER_ABSENT,
                .decoder      = EM28XX_TVP5150,
                .input          = { {
                        .type     = EM28XX_VMUX_COMPOSITE0,
                        .vmux     = TVP5150_COMPOSITE0,
                        .amux     = 1,
                }, {
                        .type     = EM28XX_VMUX_SVIDEO,
                        .vmux     = TVP5150_SVIDEO,
                        .amux     = 1,
                } },
        },
....
/* I2C devicelist hash table for devices with generic USB IDs */
static struct em28xx_hash_table em28xx_i2c_hash[] = {
        {0x77800080, EM2860_BOARD_FISSION_DK8703, TUNER_ABSENT},
....

Is it possible that the em28xx driver has incorrectly detected a
TVP5150 decoder? I notice that .../drivers/media/video/tvp5150.c seems
to suggest that there's always a TV input?

        switch (decoder->route.input) {
        case TVP5150_COMPOSITE1:
                input |= 2;
                /* fall through */
        case TVP5150_COMPOSITE0:
                opmode=0x30;            /* TV Mode */
                break;
        case TVP5150_SVIDEO:
        default:
                input |= 1;
                opmode=0;               /* Auto Mode */
                break;
	}

Am I thinking along the correct lines? Missing something? As I said,
I'm no C coder, but I'll give stuff a go :)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
