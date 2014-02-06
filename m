Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:47305 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbaBFOz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 09:55:57 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N0K000HZXH88A00@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Feb 2014 09:55:56 -0500 (EST)
Date: Thu, 06 Feb 2014 12:55:51 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Antti =?UTF-8?B?U2VwcMOkbMOk?= <a.seppala@gmail.com>,
	Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
	Jarod Wilson <jwilson@redhat.com>
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
Message-id: <20140206125551.7a1ea345@samsung.com>
In-reply-to: <52F367EC.6090607@imgtec.com>
References: <20140115173559.7e53239a@samsung.com>
 <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
 <20140121122826.GA25490@pequod.mess.org>
 <CAKv9HNZzRq=0FnBH0CD0SCz9Jsa5QzY0-Y0envMBtgrxsQ+XBA@mail.gmail.com>
 <20140122162953.GA1665@pequod.mess.org>
 <CAKv9HNbVQwAcG98S3_Mj4A6zo8Ae2fLT6vn4LOYW1UMrwQku7Q@mail.gmail.com>
 <20140122210024.GA3223@pequod.mess.org> <20140122200142.002a39c2@samsung.com>
 <CAKv9HNY7==4H2ZDrmaX+1BcarRAJd7zUE491oQ2ZJZXezpwOAw@mail.gmail.com>
 <20140204155441.438c7a3c@samsung.com>
 <CAKv9HNbYJ5FsQas=03u8pXCyiF5VSUfsOR46McukeisqVHme+g@mail.gmail.com>
 <52F206D5.9060601@imgtec.com> <52F2077E.5040901@imgtec.com>
 <CAKv9HNbfixr2746_4FewodYjOHO1G+TDgs9quyNeX87-KuBpbw@mail.gmail.com>
 <20140205192117.5a053aa3@samsung.com> <52F367EC.6090607@imgtec.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 06 Feb 2014 10:46:04 +0000
James Hogan <james.hogan@imgtec.com> escreveu:

> On 05/02/14 21:21, Mauro Carvalho Chehab wrote:
> > Em Wed, 05 Feb 2014 20:16:04 +0200
> > Antti Seppälä <a.seppala@gmail.com> escreveu:
> > 
> >> On 5 February 2014 11:42, James Hogan <james.hogan@imgtec.com> wrote:
> >>> On 05/02/14 09:39, James Hogan wrote:
> >>>> Hi Antti,
> >>>>
> >>>> On 05/02/14 07:03, Antti Seppälä wrote:
> >>>>> To wake up with nuvoton-cir we need to program several raw ir
> >>>>> pulse/space lengths to the hardware and not a scancode. James's
> >>>>> approach doesn't support this.
> >>>>
> >>>> Do the raw pulse/space lengths your hardware requires correspond to a
> >>>> single IR packet (mapping to a single scancode)?
> >>>>
> >>>> If so then my API is simply at a higher level of abstraction. I think
> >>>> this has the following advantages:
> >>>> * userspace sees a consistent interface at the same level of abstraction
> >>>> as it already has access to from input subsystem (i.e. scancodes). I.e.
> >>>> it doesn't need to care which IR device is in use, whether it does
> >>>> raw/hardware decode, or the details of the timings of the current protocol.
> >>>> * it supports hardware decoders which filter on the demodulated data
> >>>> rather than the raw pulse/space lengths.
> >>>>
> >>>> Of course to support this we'd need some per-protocol code to convert a
> >>>> scancode back to pulse/space lengths. I'd like to think that code could
> >>>> be generic, maybe as helper functions which multiple drivers could use,
> >>>> which could also handle corner cases of the API in a consistent way
> >>>> (e.g. user providing filter mask covering multiple scancodes, which
> >>>> presumably pulse/space).
> >>>
> >>> hmm, I didn't complete that sentence :(.
> >>> I meant:
> >>> ..., which presumably pulse/space can't really represent very easily).
> >>>
> >>> Cheers
> >>> James
> >>>
> >>>>
> >>>> I see I've just crossed emails with Mauro who has just suggested
> >>>> something similar. I agree that his (2) is the more elegant option.
> >>>>
> >>
> >> Yes, in nuvoton the ir pulses correspond to a scancode (or part of a scancode)
> >>
> >> After giving it some thought I agree that using scancodes is the most
> >> elegant way for specifying wakeup commands. Too bad that nuvoton does
> >> not work with scancodes.
> >> I pretty much agree with Mauro that the right solution would be to
> >> write an IR encoder and use it to convert the given scancode back to a
> >> format understood by nuvoton.
> > 
> > Ok, as we all agreed, I'll merge the remaining patches from James.
> 
> Thanks :)

Well, Rob asked some changes at the DT binding pathes. I'll tag the
patches as changes requested. Please re-submit the remaining ones after
fixing the pointed issues and getting his ack. Except for that, the
series look OK on my eyes.

> > 
> >> Writing IR encoders for all the protocols and an encoder selector
> >> functionality is quite labourous and sadly I don't have time for that
> >> anytime soon. If anyone wants to step up I'd be more than happy to
> >> help though :)
> > 
> > I suspect that writing one IR encoder should not be hard, as there
> > are already some on LIRC userspace.
> > 
> > I would love to have some time to write at least a few IR encoders,
> > but, unfortunately, I would not have any time soon.
> 
> For fun, I did some experimentation yesterday evening with adding basic
> generic IR encoding (just NEC implemented so far). Encoders can
> certainly be a lot simpler than decoders.

Yes, you don't need to deal with time shifts there, nor with missing
events ;)

Well, using the encoders also for TX (as an another ioctl at LIRC) 
would require some extra bits to handle things like carrier frequency,
duty cycle, etc, but lirc should be able to handle those already.

So, a future patch expanding its usage to lirc would just need to
add the proper binding.

Btw, I just noticed that the LIRC UAPI interface is still at the
wrong place. It is at:
	include/media/lirc.h
but it should be at:
	include/uapi/.../lirc.h

I'm wandering why nobody didn't notice it yet when compiling
Lirc userspace... Perhaps userspace is just keeping a copy of
that file without any process to sync it from the Kernel userspace
headers.

> I'll submit a few RFC patches later so Antti can see whether it would be
> suitable for nuvoton.

Thanks for that!

Regards,
Mauro
