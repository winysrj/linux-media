Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48970 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbZLHQK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 11:10:29 -0500
Received: by fxm5 with SMTP id 5so6367303fxm.28
        for <linux-media@vger.kernel.org>; Tue, 08 Dec 2009 08:10:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <303a8ee30909140906h7a3dc120u6c63d2431a156239@mail.gmail.com>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
	 <20090907124934.GA8339@systol-ng.god.lan>
	 <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
	 <20090907151809.GA12556@systol-ng.god.lan>
	 <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
	 <20090908212733.GA19438@systol-ng.god.lan>
	 <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com>
	 <20090909140147.GA24722@systol-ng.god.lan>
	 <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com>
	 <303a8ee30909140906h7a3dc120u6c63d2431a156239@mail.gmail.com>
Date: Tue, 8 Dec 2009 17:10:35 +0100
Message-ID: <db09c9680912080810r16b5aae7v800114f4e894bbbd@mail.gmail.com>
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
From: Sander Pientka <cumulus0007@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I accidently sent this mail to Michael's private address, I'm sorry for that.

Hi,

I bought the same card a couple of months ago and back then, it just
wouldn't work. I set up a wiki page, which henk has updated with links
to patches, to document the card as well as possible. I set up a
thread on this mailing list
(http://osdir.com/ml/video4linux-list/2009-05/msg00102.html) on making
the card work, but that resulted to nothing. I was surprised to find
this thread when I accidently searched for "Zolid" in my mailbox. I'm
at my internship at the moment, but I'll try this patch as soon as I
get home :)

If you need the card for further development/testing: I'm willing to
send it to you by mail. I just want it back when you're done testing,
so I can finally watch tv on my computer :)


Greetings, Sander Pientka


2009/9/14 Michael Krufky <mkrufky@kernellabs.com>:
> On Wed, Sep 9, 2009 at 11:08 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
>> On Wed, Sep 9, 2009 at 10:01 AM,  <spam@systol-ng.god.lan> wrote:
>>> On Tue, Sep 08, 2009 at 05:57:12PM -0400, Michael Krufky wrote:
>>>>
>>>> Henk,
>>>>
>>>> Why do you expect a 8295?  If your board uses the SAA7131, then we
>>>> would expect an 8290 IF demod.
>>>>
>>>> Ah, I just checked the history of this email thread -- I must have
>>>> read one of your previous emails too quickly.  :-)  Perhaps there is a
>>>> typo in the document that you read -- tda8290 is correct.
>>>>
>>> Just to come back to this point,
>>>
>>> Well zolid has a SAA7131E, if you look at the datasheet (botom of page 15)
>>> http://www.nxp.com/acrobat_download/datasheets/SAA7131E_3.pdf
>>>
>>> it says:
>>> "The SAA7131E is functionally compatible with the SAA7135 audio and video
>>> broadcast decoder device and the stand-alone low-IF device TDA8295."
>>>
>>> So thats why I asked.
>>>
>>> Regards,
>>> Henk
>>>
>>
>> FIX YOUR MAILER!!
>>
>> It's a pain to reply to your emails -- I have to insert your actual
>> email address each time :-(
>>
>> Anyway, I am under the impression that it's a typo in the datasheet.
>> It is actually a tda8290.
>
> Henk,
>
> Just FYI, I merged your patch to my saa7134 repository last week:
>
> http://www.kernellabs.com/hg/~mkrufky/saa7134
>
> I thought that I had replied to you already but that message seems to
> have gotten dropped somewhere :-/
>
> I intend to send a pull request to Mauro for this, in addition to some
> other pending patches after he merges what I have already pending.
>
> Thanks again for your work.
>
> Regards,
>
> Mike Krufky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
