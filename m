Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3983 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZCEMHh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 07:07:37 -0500
Message-ID: <54836.62.70.2.252.1236254830.squirrel@webmail.xs4all.nl>
Date: Thu, 5 Mar 2009 13:07:10 +0100 (CET)
Subject: Re: saa7134 and RDS
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Dmitri Belimov" <d.belimov@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	"hermann pitton" <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans
>
> I build fresh video4linux with your patch and my config for our cards.
> In a dmesg i see : found RDS decoder.
> cat /dev/radio0 give me some slow junk data. Is this RDS data??
> Have you any tools for testing RDS?
> I try build rdsd from Hans J. Koch, but build crashed with:
>
> rdshandler.cpp: In member function ‘void
> std::RDShandler::delete_client(std::RDSclient*)’:
> rdshandler.cpp:363: error: no matching function for call to
> ‘find(__gnu_cxx::__normal_iterator<std::RDSclient**,
> std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> __gnu_cxx::__normal_iterator<std::RDSclient**,
> std::vector<std::RDSclient*, std::allocator<std::RDSclient*> > >,
> std::RDSclient*&)’

Ah yes, that's right. I had to hack the C++ source to make this compile.
I'll see if I can post a patch for this tonight.

          Hans

> P.S. Debian Lenny.
>
> With my best regards, Dmitry.
>
>> On Wednesday 04 March 2009 13:02:46 Dmitri Belimov wrote:
>> > > Dmitri,
>> > >
>> > > I have a patch pending to fix this for the saa7134 driver. The i2c
>> > > problems are resolved, so this shouldn't be a problem anymore.
>> >
>> > Good news!
>> >
>> > > The one thing that is holding this back is that I first want to
>> > > finalize the RFC regarding the RDS support. I posted an RFC a few
>> > > weeks ago, but I need to make a second version and for that I
>> > > need to do a bit of research into the US version of RDS. And I
>> > > haven't found the time to do that yet.
>> >
>> > Yes, I found your discussion in linux-media mailing list. If you
>> > need any information from chip vendor I'll try find. I can get it
>> > under NDA and help you.
>> >
>> > > I'll see if I can get the patch merged anyway.
>>
>> I've attached my patch for the saa7134. I want to wait with the final
>> pull request until I've finished the RDS RFC, but this gives you
>> something to play with.
>>
>> Regards,
>>
>> 	Hans
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

