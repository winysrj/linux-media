Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932741AbeFPMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Jun 2018 08:46:39 -0400
Date: Sat, 16 Jun 2018 15:46:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?6rmA7KSA7ZmY?= <spilit464@gmail.com>
Cc: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, devel@driverdev.osuosl.org,
        Greg KH <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: staging: atomisp: add a blank line after
 declarations
Message-ID: <20180616124621.onqmaamidzjdyzlj@mwanda>
References: <2750553.3y1WJKmnP5@joonhwan-virtualbox>
 <20180616090609.s5s4q2ri7e2x24oo@mwanda>
 <CAO-p-6CXp1LNMciC2WsT4S-+oubh6SLYHs+4rfmQP9m88F12iA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO-p-6CXp1LNMciC2WsT4S-+oubh6SLYHs+4rfmQP9m88F12iA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 16, 2018 at 07:20:54PM +0900, 김준환 wrote:
> Thank you for attention :)
> 
> I knew what I forgot before doing contribute
> 
> I updated it 'TODAY' and I'll never repeat this mistake again!
> 

No rush.

This is a tiny mistake and doesn't affect runtime at all and we're all
human.  The thing to do is figure out which are avoidable mistakes,
right?

Like for me, when I was starting out I wrote some patches that added
some allocations but I forgot to add the kfree().  So then I made a QC
script that runs some static checkers over my patches and if I add any
line with "alloc" in it then my QC script asks me:

if git diff $fullname | grep ^+ | grep -qi alloc ; then
    qc "Have you freed all your mallocs?"
    qc "Have you checked all your mallocs for NULL returns?"
fi

And a couple weeks ago, I accidentally introduced a bug, which someone
caught during review, because I removed a cast that I thought was
unnecessary.

	for (i = 0; i < (int)limit; i++) {

I thought limit couldn't be negative but I was wrong.  So I wrote a
static checker test for that so I'll never do it again.  And I found
some similar bugs in other people's code and fixed those.  Static
analysis is sort of my thing but anyone could do it really.  Or ask
Julia and I to write a check.  But most people have the hardware and
could write a test program to trigger the bug and add it to their QC
process.

So making mistakes is fine and it's part of learning.  You should
definitely take the time to figure out where you went wrong and if it's
preventable.  But no one really gets annoyed about mistakes because it's
just part of life and being human.

regards,
dan carpenter
