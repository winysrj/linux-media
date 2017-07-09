Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:40888 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752407AbdGIR6f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 13:58:35 -0400
Message-ID: <1499623111.5468.1.camel@perches.com>
Subject: Re: [PATCH] checkpatch: fixed alignment and comment style
From: Joe Perches <joe@perches.com>
To: Philipp Guendisch <philipp.guendisch@fau.de>, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        jeremy.lefaure@lse.epita.fr, fabf@skynet.be, rvarsha016@gmail.com,
        chris.baller@gmx.de, robsonde@gmail.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Date: Sun, 09 Jul 2017 10:58:31 -0700
In-Reply-To: <1499621986-29717-1-git-send-email-philipp.guendisch@fau.de>
References: <1499621986-29717-1-git-send-email-philipp.guendisch@fau.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-07-09 at 19:39 +0200, Philipp Guendisch wrote:
> This patch fixed alignment, comment style and one appearance of
> misordered constant in an if comparison.
> Semantic should not be affected by this patch.

Your email subject is wrong.  This is not a checkpatch patch.

Your subject line should be something like:

[PATCH] staging: atomisp2: hmm: Alignment code to open parenthesis

And it's probably more likely to be applied if you separate out
the two different types of changes you are making into 2 patches.
