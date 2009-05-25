Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:35467 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbZEYWDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 18:03:39 -0400
Received: by ewy24 with SMTP id 24so3282397ewy.37
        for <linux-media@vger.kernel.org>; Mon, 25 May 2009 15:03:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0905221951l2a1dd0d5k28fe0bf8622d6461@mail.gmail.com>
References: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
	 <1241140865.3210.108.camel@palomino.walls.org>
	 <303162d70904301855xd138162s43c550637436919a@mail.gmail.com>
	 <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
	 <412bdbff0904302216q4ffbdf24yb5d73956addfb8f6@mail.gmail.com>
	 <303162d70905012017x2f6a2ae7n4600ecb5bb26be89@mail.gmail.com>
	 <412bdbff0905221951l2a1dd0d5k28fe0bf8622d6461@mail.gmail.com>
Date: Mon, 25 May 2009 16:03:40 -0600
Message-ID: <303162d70905251503oa18abeen7a65231125ee1ca8@mail.gmail.com>
Subject: Re: [PATCH] Add QAM64 support for hvr-950q (au8522)
From: Frank Dischner <phaedrus961@googlemail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

> Do you have the USB trace you used as the basis for this dump?  And
> did you programatically parse that dump to generate the table, or did
> you enter it by hand?  Could you please email me the underlying dump
> so I can double check the data?

I wrote a program to parse the trace and make it more readable, but I
entered the table by hand. Unfortunately, I no longer have any qam
traces. I can make a new one, if you'd like, but it'll have to wait
until I have time to install windows.

> I think the correct approach here would be to have three tables, a
> table of common registers, and two tables, one for each modulation
> type.  It would program the common registers first, and then pick the
> correct table to program the rest.  If we are concerned about the
> order that the registers are being programmed in, we can just setup
> the two tables so they start at the first register which is different
> (since it is almost at the bottom of the table anyway).

I didn't notice how similar they were when writing the patch, thanks
for pointing it out! I'll do some tests and see how much can be
combined into a common table.

While I'm at it, I thought I'd go ahead and make a patch to remove the
top bits from the vsb table, but I've got a question about that. I
think the first four entries are unnecessary. I'm pretty sure 8090 and
8091 have to do with the 8522's i2c controller and 4092 is a status
register. I have no idea what 2005 is, but the new code would change
it to A005 and I don't remember seeing either in any of the traces I
did (though I never did a vsb trace). Is this correct or am I missing
something? If I make a patch, can you or someone else test it for me?
(can't get a signal here)

Frank
