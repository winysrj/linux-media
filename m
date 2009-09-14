Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f185.google.com ([209.85.221.185]:59879 "EHLO
	mail-qy0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZINQGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 12:06:43 -0400
Received: by qyk15 with SMTP id 15so2414140qyk.15
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 09:06:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
	 <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com>
	 <20090907124934.GA8339@systol-ng.god.lan>
	 <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
	 <20090907151809.GA12556@systol-ng.god.lan>
	 <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
	 <20090908212733.GA19438@systol-ng.god.lan>
	 <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com>
	 <20090909140147.GA24722@systol-ng.god.lan>
	 <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com>
Date: Mon, 14 Sep 2009 12:06:39 -0400
Message-ID: <303a8ee30909140906h7a3dc120u6c63d2431a156239@mail.gmail.com>
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk.Vergonet@gmail.com
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 9, 2009 at 11:08 AM, Michael Krufky <mkrufky@kernellabs.com> wrote:
> On Wed, Sep 9, 2009 at 10:01 AM,  <spam@systol-ng.god.lan> wrote:
>> On Tue, Sep 08, 2009 at 05:57:12PM -0400, Michael Krufky wrote:
>>>
>>> Henk,
>>>
>>> Why do you expect a 8295?  If your board uses the SAA7131, then we
>>> would expect an 8290 IF demod.
>>>
>>> Ah, I just checked the history of this email thread -- I must have
>>> read one of your previous emails too quickly.  :-)  Perhaps there is a
>>> typo in the document that you read -- tda8290 is correct.
>>>
>> Just to come back to this point,
>>
>> Well zolid has a SAA7131E, if you look at the datasheet (botom of page 15)
>> http://www.nxp.com/acrobat_download/datasheets/SAA7131E_3.pdf
>>
>> it says:
>> "The SAA7131E is functionally compatible with the SAA7135 audio and video
>> broadcast decoder device and the stand-alone low-IF device TDA8295."
>>
>> So thats why I asked.
>>
>> Regards,
>> Henk
>>
>
> FIX YOUR MAILER!!
>
> It's a pain to reply to your emails -- I have to insert your actual
> email address each time :-(
>
> Anyway, I am under the impression that it's a typo in the datasheet.
> It is actually a tda8290.

Henk,

Just FYI, I merged your patch to my saa7134 repository last week:

http://www.kernellabs.com/hg/~mkrufky/saa7134

I thought that I had replied to you already but that message seems to
have gotten dropped somewhere :-/

I intend to send a pull request to Mauro for this, in addition to some
other pending patches after he merges what I have already pending.

Thanks again for your work.

Regards,

Mike Krufky
