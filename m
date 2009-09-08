Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.221.181]:47927 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZIHBWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 21:22:07 -0400
Received: by qyk11 with SMTP id 11so2402052qyk.1
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 18:22:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090907194007.37c222cc@caramujo.chehab.org>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	 <37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
	 <20090907021002.2f4d3a57@caramujo.chehab.org>
	 <37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
	 <20090907030652.04e2d2a3@caramujo.chehab.org>
	 <1252340384.3146.52.camel@palomino.walls.org>
	 <37219a840909070925k25ed146bn9c3725596c9490b9@mail.gmail.com>
	 <20090907183632.195dc3e5@caramujo.chehab.org>
	 <37219a840909071521j67e9c3d6h1e9b2e1a8ded45cd@mail.gmail.com>
	 <20090907194007.37c222cc@caramujo.chehab.org>
Date: Mon, 7 Sep 2009 21:22:09 -0400
Message-ID: <303a8ee30909071822jfa6c932i41f3dc3a97684b2c@mail.gmail.com>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
	firmware name
From: Michael Krufky <mkrufky@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@radix.net>, linuxtv-commits@linuxtv.org,
	Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 7, 2009 at 6:40 PM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> Em Mon, 7 Sep 2009 18:21:01 -0400
> Michael Krufky <mkrufky@kernellabs.com> escreveu:
>
>> Mauro,
>>
>> For the Conexant *reference designs* the firmwares are identical, yes.
>>
>> If you look at the windows drivers, there are some additional bits
>> used for separate firmwares depending on which actual silicon is
>> present.  This is specific to the implementation by the vendors.
>
> If firmware versions are vendor-specific, then the patch "cx25840: fix
> determining the  firmware name" doesn't work, since people may have two boards
> with the same silicon from different vendors, each requiring his own
> vendor-specific firmware.
>
> The solution seems to have a setup parameter with the firmware name, adding the
> firmware name at the *-cards.c, like what's done with xc3028 firmwares. This
> also means that we need vendor's rights to distribute the specific firmwares.
>>
>> Not everybody is using the firmware images that you are pointing at...
>>  There is in fact a need to keep the filenames separate.  Some
>> firmware for one silicon may conflict with firmware for other silicon.
>>
>> -Mike

Let me clarify:

As far as I understand, there are some additional bits in the cx23885
firmware for use with certain vendor-specific stuff.  That cx23885
firmware is compatible with all other cx23885 firmware, but not
necessarily the cx25840.

Likewise, there are some additional bits in the cx25840 firmware for
certain vendor-specific stuff, that is compatible with all other
cx25840 firmware, but not necessarily the cx23885.

As I understand, if additional bits are added for a specific product,
they might be added to the firmware in addition to the other bits
already present for *that* firmware image.  This means, any cx23885
firmware is OK to use for any cx23885, and any cx25840 firmware is OK
to use for any cx25840.

You will notice that most of these images can be interchanged between
one another, but the additional bits are specific to the flavor of the
silicon.

There is no actual vendor-specific firmware -- all firmware for these
parts are uniform for that part.  However, there are some
cx23885-specific bits that only apply to the cx23885, just as there
may be some cx25840-specific bits that only apply to the cx25840.

I dont know how to explain this any clearer.

One thing that might be a good idea -- perhaps the bridge-level driver
that needs to attach the cx25840 module should specify to the cx25840
module the filename of the firmware that should be requested.  A
module option would *not* be the best idea -- we should not expect
users to know about this.  Perhaps a default firmware filename could
be named by cx25840.  *but*  we should not simply cause every driver
to all use the same filename unless the original driver author can
vouch for this as the appropriate course of action.

Regards,

Mike
