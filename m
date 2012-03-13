Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47368 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2CMPWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 11:22:39 -0400
Received: by eekc41 with SMTP id c41so308428eek.19
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2012 08:22:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120307T170824-19@post.gmane.org>
References: <4EF67721.9050102@unixsol.org>
	<4EF6DD91.2030800@iki.fi>
	<4EF6F84C.3000307@redhat.com>
	<CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com>
	<4EF7066C.4070806@redhat.com>
	<loom.20111227T105753-96@post.gmane.org>
	<CAF0Ff2mf0tYs3UG3M6Cahep+_kMToVaGgPhTqR7zhRG0UXWuig@mail.gmail.com>
	<85A7A8FC-150C-4463-B09C-85EED6F851A8@cosy.sbg.ac.at>
	<CAF0Ff2ncv0PJWSOOw=7WeGyqX3kKiQitY52uEOztfC8Bwj6LgQ@mail.gmail.com>
	<CAB0B130-3B08-41B4-920A-C54058C43AEE@cosy.sbg.ac.at>
	<CAF0Ff2kF3VCL4PomOo5zBBrZSPmPvGd9qSZ+XwSp7ALJmq3+kw@mail.gmail.com>
	<78E6697C-BD32-4062-BC2C-A5F7D0CBD79C@cosy.sbg.ac.at>
	<CAF0Ff2nCz114LEJFRXy+L7Yq-uD4+sJeHOzNSk=28V_qgbta7A@mail.gmail.com>
	<loom.20120307T170824-19@post.gmane.org>
Date: Tue, 13 Mar 2012 17:22:37 +0200
Message-ID: <CAF0Ff2n1wj5LTu935sR6jxYP8ncHHEA=f6urs8+QKcD2Zd04zg@mail.gmail.com>
Subject: Re: DVB-S2 multistream support
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Bob Winslow <bob.news@non-elite.com>
Cc: linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi Bob,

all work to support BBFrames in the Linux kernel is done by Christian
- in fact it's a long lost work from 5 years ago:

http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022217.html

and i hope it won't be lost again. i just encouraged Christian that
his work is important and there are people interested in it - you're
one such example. so, i offered Christian to help him with i can. i
guess more people appreciating what his doing and encourage him will
give him better motivation to release the code to the public. however,
i guess the delay is more, because it's not easy and it requires time
to prepare the code for initial public release and that's why the
delay. so, i don't have Christian's code and i'm eager as you're to be
able to try it out, but we need to be patient. i'm sure that after
there is some public release and repository more people will be
interested to contribute to that work.

best regards,
konstantin

On Wed, Mar 7, 2012 at 6:33 PM, Bob Winslow <bob.news@non-elite.com> wrote:
>
>> that's really great news! i'm looking forward to look at the code when
>> the public repository is ready. i'm sure i'm not the only one and the
>> news would be especially exciting for TBS 6925 owners, which use
>> Linux, but it's away beyond that, because the real news here is
>> working base-band support in 'dvb-core' of V4L. also, it's really good
>> that SAA716x code seems to just work with BBFrames and no further
>> changes are required there.
>>
>
> Hi Christian, Konstantin,
>
>
>  Well, my TBS 6925 just came in the mail yesterday and I am excited to plug it
> in and start playing with it.  Your work on the bb-demux looks like a good place
> to start playing with the card under linux.
>
>  Have you setup a public repo yet for the band band support (bb-demux) ?
>
> Also, I downloaded the linux drivers for the card from the TBS dtv site, and put
> them on my ubuntu 11.10 pc.  They seem to work.   Is this the best place to get
> drivers for the card??  the front end driver files seem to be just .o's and the
> source is not in the tarball.
>
> Sorry, I'm a bit new to the dvb world and I am still learning where to find
> stuff.  Any pointers/help to finding the latest code/drivers would be very much
> appreciated.
>
>
> Kind regards,
>
>  Bob
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
