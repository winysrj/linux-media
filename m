Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:48804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab0JINDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 09:03:32 -0400
Message-ID: <4CB06806.2070900@infradead.org>
Date: Sat, 09 Oct 2010 10:03:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Paul Walmsley <paul@booyaka.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: tvp5150: COMPOSITE0 input should not force-enable
 TV mode
References: <alpine.DEB.2.00.1010082229160.15379@utopia.booyaka.com> <AANLkTinhS=GOV=1uR6H=9_=S-nyirdm6Z7HF6N5wKw2T@mail.gmail.com>
In-Reply-To: <AANLkTinhS=GOV=1uR6H=9_=S-nyirdm6Z7HF6N5wKw2T@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-10-2010 09:33, Devin Heitmueller escreveu:
> On Sat, Oct 9, 2010 at 12:31 AM, Paul Walmsley <paul@booyaka.com> wrote:
>>
>> When digitizing composite video from a analog videotape source using the
>> TVP5150's first composite input channel, the captured stream exhibits
>> tearing and synchronization problems[1].
>>
>> It turns out that commit c0477ad9feca01bd8eff95d7482c33753d05c700 caused
>> "TV mode" (as opposed to "VCR mode" or "auto-detect") to be forcibly
>> enabled for both composite inputs.  According to the chip
>> documentation[2], "TV mode" disables a "chrominance trap" input filter,
>> which appears to be necessary for high-quality video capture from an
>> analog videotape source.  [ Commit
>> c7c0b34c27bbf0671807e902fbfea6270c8f138d subsequently restricted the
>> problem to the first composite input, apparently inadvertently. ]
> 
> FYI:  This isn't a newly discovered issue:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg13869.html

Yeah. I basically asked people to do more tests, but never got any feedback
about that issue. Provided that it won't break anything, I'm ok on merging
it.

Cheers,
Mauro
