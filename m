Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57778 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaBESQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 13:16:07 -0500
Received: by mail-qa0-f44.google.com with SMTP id w5so1116304qac.3
        for <linux-media@vger.kernel.org>; Wed, 05 Feb 2014 10:16:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F2077E.5040901@imgtec.com>
References: <20140115173559.7e53239a@samsung.com>
	<1390246787-15616-1-git-send-email-a.seppala@gmail.com>
	<20140121122826.GA25490@pequod.mess.org>
	<CAKv9HNZzRq=0FnBH0CD0SCz9Jsa5QzY0-Y0envMBtgrxsQ+XBA@mail.gmail.com>
	<20140122162953.GA1665@pequod.mess.org>
	<CAKv9HNbVQwAcG98S3_Mj4A6zo8Ae2fLT6vn4LOYW1UMrwQku7Q@mail.gmail.com>
	<20140122210024.GA3223@pequod.mess.org>
	<20140122200142.002a39c2@samsung.com>
	<CAKv9HNY7==4H2ZDrmaX+1BcarRAJd7zUE491oQ2ZJZXezpwOAw@mail.gmail.com>
	<20140204155441.438c7a3c@samsung.com>
	<CAKv9HNbYJ5FsQas=03u8pXCyiF5VSUfsOR46McukeisqVHme+g@mail.gmail.com>
	<52F206D5.9060601@imgtec.com>
	<52F2077E.5040901@imgtec.com>
Date: Wed, 5 Feb 2014 20:16:04 +0200
Message-ID: <CAKv9HNbfixr2746_4FewodYjOHO1G+TDgs9quyNeX87-KuBpbw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 February 2014 11:42, James Hogan <james.hogan@imgtec.com> wrote:
> On 05/02/14 09:39, James Hogan wrote:
>> Hi Antti,
>>
>> On 05/02/14 07:03, Antti Seppälä wrote:
>>> To wake up with nuvoton-cir we need to program several raw ir
>>> pulse/space lengths to the hardware and not a scancode. James's
>>> approach doesn't support this.
>>
>> Do the raw pulse/space lengths your hardware requires correspond to a
>> single IR packet (mapping to a single scancode)?
>>
>> If so then my API is simply at a higher level of abstraction. I think
>> this has the following advantages:
>> * userspace sees a consistent interface at the same level of abstraction
>> as it already has access to from input subsystem (i.e. scancodes). I.e.
>> it doesn't need to care which IR device is in use, whether it does
>> raw/hardware decode, or the details of the timings of the current protocol.
>> * it supports hardware decoders which filter on the demodulated data
>> rather than the raw pulse/space lengths.
>>
>> Of course to support this we'd need some per-protocol code to convert a
>> scancode back to pulse/space lengths. I'd like to think that code could
>> be generic, maybe as helper functions which multiple drivers could use,
>> which could also handle corner cases of the API in a consistent way
>> (e.g. user providing filter mask covering multiple scancodes, which
>> presumably pulse/space).
>
> hmm, I didn't complete that sentence :(.
> I meant:
> ..., which presumably pulse/space can't really represent very easily).
>
> Cheers
> James
>
>>
>> I see I've just crossed emails with Mauro who has just suggested
>> something similar. I agree that his (2) is the more elegant option.
>>

Yes, in nuvoton the ir pulses correspond to a scancode (or part of a scancode)

After giving it some thought I agree that using scancodes is the most
elegant way for specifying wakeup commands. Too bad that nuvoton does
not work with scancodes.
I pretty much agree with Mauro that the right solution would be to
write an IR encoder and use it to convert the given scancode back to a
format understood by nuvoton.

Writing IR encoders for all the protocols and an encoder selector
functionality is quite labourous and sadly I don't have time for that
anytime soon. If anyone wants to step up I'd be more than happy to
help though :)

-Antti
