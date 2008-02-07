Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17JeRU2008015
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 14:40:27 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17Je5FC031683
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 14:40:05 -0500
Date: Thu, 7 Feb 2008 17:39:26 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Adrian Pardini" <pardo.bsso@gmail.com>
Message-ID: <20080207173926.53b9e0ce@gaivota>
In-Reply-To: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>
References: <9c4b1d600802071009q7fc69d4cj88c3ec2586e484a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] New card entry (saa7134) and FM support for TNF9835
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

The patch looks sane. A few comments:

On Thu, 7 Feb 2008 16:09:48 -0200
"Adrian Pardini" <pardo.bsso@gmail.com> wrote:

> Hello,
> This patch brings complete functionality to the "Genius TVGo A11MCE" (saa7130,
> tuner is TNF9835) proper audio/video routing, fm tunning and remote control.
> 
> Things I've done:
>   * New entry for the card.
>   * New entry for the tuner. It's a TNF9835, as the wiki says it works
> fine for tv using
>      tuner=37 but the datasheet specifies different frequency bands and the i2c
>      command used to tune fm is other.
>   * Key mappings for the remote control.
> 
> Files changed:
>   ir-common.h
>   ir-keymaps.c
>   saa7134.h
>   saa7134-cards.c
>   saa7134-input.c
>   tuner.h
>   tuner-simple.c
>   tuner-types.c
> 
> Testing:
>   I successfully built and tested it ( with the sources from
> mercurial) using Ubuntu Gutsy(linux 2.6.22, custom) and Musix
> 1.0r3-test5 (2.6.23-rt1)
> 
> Notes:
>   I get this message from time to time and I don't know what to do:
>   "saa7130[0]/irq: looping -- clearing PE (parity error!) enable bit"
> 
>   I didn't want to mess with the pci ids table.
>   Without using the card= parameter it is detected as being an
> "Philips TOUGH DVB-T reference design [card=61,autodetected]".
>   lspci output:
> 00:0c.0 Multimedia controller: Philips Semiconductors SAA7130 Video
> Broadcast Decoder (rev 01)
>         Subsystem: Philips Semiconductors Unknown device 2004
>         Flags: bus master, medium devsel, latency 64, IRQ 11
>         Memory at dffffc00 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [40] Power Management version 1
> 
> I'm wide open to accept suggestions and corrections.
> Thanks a lot for your time,
> Adrian.

Hmmm... what a big changelog... Better to write it more summarized ;)

> ---
> diff -uprN -X dontdiff v4l-dvb/linux/drivers/media/common/ir-keymaps.c
> v4l-dvb-modified/linux/drivers/media/common/ir-keymaps.c
> --- v4l-dvb/linux/drivers/media/common/ir-keymaps.c	2008-02-06
> 22:54:07.000000000 -0200
> +++ v4l-dvb-modified/linux/drivers/media/common/ir-keymaps.c	2008-02-07
> 12:10:06.000000000 -0200

Your e-mail arrived word-wrapped. Please, don't let your emailer to break lines
into 80 columns, otherwise, patch won't apply.
> +	[ 0x48 ] = KEY_0,

There are CodingStyle violations here (*). The proper way is:
	 [0x48] = KEY_0

(*) yes, I know that this is already present at the current code. However,
newer patches should bind to CodingStyle. Later, someone may fix the current
code.

> +static struct tuner_range tuner_tnf9835_ranges[] = {
> +	{ 16 * 161.25 /*MHz*/, 0x8e, 0x01, },
> +	{ 16 * 463.25 /*MHz*/, 0x8e, 0x02, },
> +	{ 16 * 999.99        , 0x8e, 0x08, },
> +};

> +	[TUNER_TNF9835] = {
> +		.name   = "TNF9835 FM / PAL B-BG / NTSC",
> +		.params = tuner_tnf9835_params,
> +		.count = ARRAY_SIZE(tuner_tnf9835_params),
> +	},

Hmm... the same tuner works for both PAL and NTSC standards? Are you sure about
the frequency ranges? I was expecting to have the same frequency for all
tnfxx35 tuners, although I don't have a datasheet for tnf9835.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
