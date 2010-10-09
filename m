Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55466 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab0JIMdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 08:33:22 -0400
Received: by ewy20 with SMTP id 20so34618ewy.19
        for <linux-media@vger.kernel.org>; Sat, 09 Oct 2010 05:33:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1010082229160.15379@utopia.booyaka.com>
References: <alpine.DEB.2.00.1010082229160.15379@utopia.booyaka.com>
Date: Sat, 9 Oct 2010 08:33:20 -0400
Message-ID: <AANLkTinhS=GOV=1uR6H=9_=S-nyirdm6Z7HF6N5wKw2T@mail.gmail.com>
Subject: Re: [PATCH] V4L/DVB: tvp5150: COMPOSITE0 input should not
 force-enable TV mode
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Paul Walmsley <paul@booyaka.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Oct 9, 2010 at 12:31 AM, Paul Walmsley <paul@booyaka.com> wrote:
>
> When digitizing composite video from a analog videotape source using the
> TVP5150's first composite input channel, the captured stream exhibits
> tearing and synchronization problems[1].
>
> It turns out that commit c0477ad9feca01bd8eff95d7482c33753d05c700 caused
> "TV mode" (as opposed to "VCR mode" or "auto-detect") to be forcibly
> enabled for both composite inputs.  According to the chip
> documentation[2], "TV mode" disables a "chrominance trap" input filter,
> which appears to be necessary for high-quality video capture from an
> analog videotape source.  [ Commit
> c7c0b34c27bbf0671807e902fbfea6270c8f138d subsequently restricted the
> problem to the first composite input, apparently inadvertently. ]

FYI:  This isn't a newly discovered issue:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg13869.html

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
