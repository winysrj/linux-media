Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:33999 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZINPVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 11:21:14 -0400
Received: by ey-out-2122.google.com with SMTP id 4so444110eyf.5
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 08:21:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090914151011.GA2295@systol-ng.god.lan>
References: <20090907124934.GA8339@systol-ng.god.lan>
	 <20090907151809.GA12556@systol-ng.god.lan>
	 <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
	 <20090908212733.GA19438@systol-ng.god.lan>
	 <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com>
	 <20090909140147.GA24722@systol-ng.god.lan>
	 <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com>
	 <20090914001447.GA15770@systol-ng.god.lan>
	 <303a8ee30909140533k728791b5p503701d4e6b14122@mail.gmail.com>
	 <20090914151011.GA2295@systol-ng.god.lan>
Date: Mon, 14 Sep 2009 11:21:17 -0400
Message-ID: <37219a840909140821l7c1abd02q30d0c1a08dc84659@mail.gmail.com>
Subject: Re: [PATCH] tda18271 add FM filter selction + minor fixes
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 14, 2009 at 11:10 AM,  <spam@systol-ng.god.lan> wrote:
> On Mon, Sep 14, 2009 at 08:33:46AM -0400, Michael Krufky wrote:
>> On Sun, Sep 13, 2009 at 8:14 PM,  <spam@systol-ng.god.lan> wrote:
>> >
>> > This patch adds support for FM filter selection. The tda18271 has two rf
>> > inputs RF_IN (45-864 MHz) and FM_IN (65-108 MHz). The code automatically
>> > enables the antialiasing filter for radio reception and depending on the
>> > FM input selected configures EB23 register.
>> >
>> > Additional fixes:
>> > - Fixed the temerature comensation, see revision history of TDA18271HD_4
>> > ?spec.
>> > - Minor cosmetic change in the tda18271_rf_band[]
>> > - Fixed one value and removed a duplicate in tda18271_cid_target[]
>> >
>> > Signed-off-by: Henk.Vergonet@gmail.com
>> >
>> >
>>
>> Henk,
>>
>> Thank you for your patch.
>>
>> I have some other tda18271 patches pending merge currently, so it will
>> be a few days before I'll be able to test and merge your patch.
>>
>> In the meanwhile, I'd request that this single patch be broken down
>> into three separate patches, each with a description of the change and
>> sign-off.  I know that the patch you sent in is small, I just prefer
>> to apply changes separately.
>>
> Thats fine, I will wait for the pull in v4l-dvb and then redo the patches:
> - FM filter selection
> - Errata temerature compensation
> - Table fixes
>
> if thast ok.
>
>> Do you have FM radio working on the Zolid board after applying this?
>
> Unfortunately not yet, I get static noise with small 'ticks' at regular
> intervals. It maybe the way I am testing. Currently I am using:
>
>        mplayer radio://91.3/capture -nocache -rawaudio rate=32000 -radio \
>                adevice=hw=1.0:arate=32000
>
> to test.
>
> I will try to see if a can solder some pin headers on the card so I can
> use audio bypass to the sound card.

Henk,

Don't wait for them to be merged to v4l-dvb -- Just work against the
tda18271 development repository:

http://kernellabs.com/hg/~mkrufky/tda18271

I maintain this driver, and I actually have some other fixes with
respect to rf tracking filter calibration / compensation that I have
yet to push.  I'm asking you to resend your patches so that I'll queue
them for the next tda18271 merge.

Regards,

Mike
