Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59568 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002Ab0FUQBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 12:01:34 -0400
Received: by ewy20 with SMTP id 20so169947ewy.19
        for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 09:01:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277135293.27109.32.camel@phat>
References: <1277132966.27109.24.camel@phat>
	<AANLkTil3akZ0OAahETLyHv9Wc0eG3UrEz3RAmsg7GSlU@mail.gmail.com>
	<1277135293.27109.32.camel@phat>
Date: Mon, 21 Jun 2010 11:55:27 -0400
Message-ID: <AANLkTimFKjpG6GwoERka-HCK9pLo7tPb9uGn7rnDwkmO@mail.gmail.com>
Subject: Re: How to use aux input on ATI TV Wonder 600 USB?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Freitas <sflist@ihonk.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 21, 2010 at 11:48 AM, Steve Freitas <sflist@ihonk.com> wrote:
>> Yes, it's fully supported.  But bear in mind it's an analog input, so
>> you need to use a V4L application as opposed to something designed for
>> DVB.  Once you use an analog app (such as tvtime), just toggle over to
>> input 1 for composite or input 2 for S-Video (input zero is the analog
>> tuner input).
>
> That was just the help I needed. Thanks! Would it be appropriate for me
> to add that input number information to the wiki page[1]?

I'm not sure how much value it would provide.  Pretty much all the
applications show an input description next to the number (for
example, with tvtime you actually see "Tuner", "Composite", and
"S-Video" as the options).

The driver shows you the mapping if you run v4l2-ctl --list-inputs.

But feel free to update the Wiki if you think it helps.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
