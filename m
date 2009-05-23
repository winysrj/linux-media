Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50033 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbZEWCvz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 22:51:55 -0400
Received: by gxk10 with SMTP id 10so3857914gxk.13
        for <linux-media@vger.kernel.org>; Fri, 22 May 2009 19:51:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <303162d70905012017x2f6a2ae7n4600ecb5bb26be89@mail.gmail.com>
References: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
	 <1241140865.3210.108.camel@palomino.walls.org>
	 <303162d70904301855xd138162s43c550637436919a@mail.gmail.com>
	 <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
	 <412bdbff0904302216q4ffbdf24yb5d73956addfb8f6@mail.gmail.com>
	 <303162d70905012017x2f6a2ae7n4600ecb5bb26be89@mail.gmail.com>
Date: Fri, 22 May 2009 22:51:56 -0400
Message-ID: <412bdbff0905221951l2a1dd0d5k28fe0bf8622d6461@mail.gmail.com>
Subject: Re: [PATCH] Add QAM64 support for hvr-950q (au8522)
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Frank Dischner <phaedrus961@googlemail.com>
Cc: Britney Fransen <britney.fransen@gmail.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 1, 2009 at 11:17 PM, Frank Dischner
<phaedrus961@googlemail.com> wrote:
> Here's the updated patch with the requested changes.
>
> Frank

Hello Frank,

Sorry for taking so long to get back to this.

I looked at the patch, and in particular, I compared the values
programmed for QAM256 against the table you provided for QAM64.  The
delta is only four registers (210, 211, 323, 502).  This isn't
terribly surprising.

A few questions:

Do you have the USB trace you used as the basis for this dump?  And
did you programatically parse that dump to generate the table, or did
you enter it by hand?  Could you please email me the underlying dump
so I can double check the data?

I think the correct approach here would be to have three tables, a
table of common registers, and two tables, one for each modulation
type.  It would program the common registers first, and then pick the
correct table to program the rest.  If we are concerned about the
order that the registers are being programmed in, we can just setup
the two tables so they start at the first register which is different
(since it is almost at the bottom of the table anyway).

That said, do you want to take a crack at the above suggested
refactoring and resubmit an updated patch, or would you prefer to have
me check in this patch as-is, and then refactor it myself afterward.
It's up to you.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
