Return-path: <mchehab@gaivota>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44061 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab0JaCcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Oct 2010 22:32:14 -0400
Received: by iwn10 with SMTP id 10so5512762iwn.19
        for <linux-media@vger.kernel.org>; Sat, 30 Oct 2010 19:32:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101030233617.GA13155@hardeman.nu>
References: <20101029031131.GE17238@redhat.com>
	<20101029031530.GH17238@redhat.com>
	<4CCAD01A.3090106@redhat.com>
	<20101029151141.GA21604@redhat.com>
	<20101029191711.GA12136@hardeman.nu>
	<20101029192733.GE21604@redhat.com>
	<20101029195918.GA12501@hardeman.nu>
	<20101029200937.GG21604@redhat.com>
	<20101030233617.GA13155@hardeman.nu>
Date: Sat, 30 Oct 2010 22:32:14 -0400
Message-ID: <AANLkTimLU1TUn6nY4pr2pWNJp1hviyx=NiXYUQLSQA0e@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Apple remote support
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, Oct 30, 2010 at 7:36 PM, David Härdeman <david@hardeman.nu> wrote:
> On Fri, Oct 29, 2010 at 04:09:37PM -0400, Jarod Wilson wrote:
>> On Fri, Oct 29, 2010 at 09:59:18PM +0200, David Härdeman wrote:
>> > On Fri, Oct 29, 2010 at 03:27:33PM -0400, Jarod Wilson wrote:
>> > > On Fri, Oct 29, 2010 at 09:17:11PM +0200, David Härdeman wrote:
>> > > > On Fri, Oct 29, 2010 at 11:11:41AM -0400, Jarod Wilson wrote:
>> > > > > So the Apple remotes do something funky... One of the four bytes is a
>> > > > > remote identifier byte, which is used for pairing the remote to a specific
>> > > > > device, and you can change the ID byte by simply holding down buttons on
>> > > > > the remote.
>> > > >
>> > > > How many different ID's are possible to set on the remote?
>> > >
>> > > 256, apparently.
>> >
>> > Does the remote pick one for you at random?
>>
>> Looks like its randomly set at the factory, then holding a particular key
>> combo on the remote for 5 seconds, you can cycle to another one. Not sure
>> if "another one" means "increment by one" or "randomly pick another one"
>> yet though.
>
> In that case, one solution would be:
>
> * using the full 32 bit scancode
> * add a module parameter to squash the ID byte to zero
> * default the module parameter to true
> * create a keymap suitable for ID = 0x00
>
> Users who really want to distinguish remotes can then change the module
> parameter and generate a keymap for their particular ID. Most others
> will be blissfully unaware of this feature.

I was thinking something similar but slightly different. I think ID =
0x00 is a valid ID byte, so I was thinking static int pair_id = -1; to
start out. This would be a stand-alone apple-only decoder, so we'd
look for the apple identifier bytes, bail if not found. We'd also look
at the ID byte, and if pair_id is 0-255, we'd bail if the ID byte
didn't match it. The scancode we'd actually use to match the key table
would be just the one command byte. It seems to make sense in my head,
at least.

-- 
Jarod Wilson
jarod@wilsonet.com
