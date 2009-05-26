Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:54954 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZEZA1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 20:27:39 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2028955ywb.1
        for <linux-media@vger.kernel.org>; Mon, 25 May 2009 17:27:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <303162d70905251503oa18abeen7a65231125ee1ca8@mail.gmail.com>
References: <B2D200D8-22B0-418C-B577-C036C1469521@gmail.com>
	 <1241140865.3210.108.camel@palomino.walls.org>
	 <303162d70904301855xd138162s43c550637436919a@mail.gmail.com>
	 <5B379A59-CAE7-4D20-8570-E3F2D6AB9623@gmail.com>
	 <412bdbff0904302216q4ffbdf24yb5d73956addfb8f6@mail.gmail.com>
	 <303162d70905012017x2f6a2ae7n4600ecb5bb26be89@mail.gmail.com>
	 <412bdbff0905221951l2a1dd0d5k28fe0bf8622d6461@mail.gmail.com>
	 <303162d70905251503oa18abeen7a65231125ee1ca8@mail.gmail.com>
Date: Mon, 25 May 2009 20:27:40 -0400
Message-ID: <412bdbff0905251727v6d5dc6c7y72d497b302d3c032@mail.gmail.com>
Subject: Re: [PATCH] Add QAM64 support for hvr-950q (au8522)
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Frank Dischner <phaedrus961@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 25, 2009 at 6:03 PM, Frank Dischner
<phaedrus961@googlemail.com> wrote:
> While I'm at it, I thought I'd go ahead and make a patch to remove the
> top bits from the vsb table, but I've got a question about that. I
> think the first four entries are unnecessary. I'm pretty sure 8090 and
> 8091 have to do with the 8522's i2c controller and 4092 is a status
> register. I have no idea what 2005 is, but the new code would change
> it to A005 and I don't remember seeing either in any of the traces I
> did (though I never did a vsb trace). Is this correct or am I missing
> something? If I make a patch, can you or someone else test it for me?
> (can't get a signal here)

Yeah, I noticed the 4092 entry.  The "4" means it's a read operation
so it almost certainly shouldn't be in the table.  I just haven't
taken the time to look closer at a Windows trace to see if it was
*really* a register read operation that got stuck into the table or
whether it was supposed to be a write operation.

I haven't reviewed the VSB table yes, so I am not sure about the other entries.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
