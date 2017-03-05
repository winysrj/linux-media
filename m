Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:45495 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751969AbdCESqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Mar 2017 13:46:09 -0500
Message-ID: <1488739360.2210.1.camel@perches.com>
Subject: Re: [Outreachy kernel] [PATCH] staging: media: Remove unnecessary
 function and its call
From: Joe Perches <joe@perches.com>
To: Alison Schofield <amsfield22@gmail.com>,
        simran singhal <singhalsimran0@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Date: Sun, 05 Mar 2017 10:42:40 -0800
In-Reply-To: <20170305181444.GA2094@d830.WORKGROUP>
References: <20170305064721.GA22548@singhal-Inspiron-5558>
         <20170305181444.GA2094@d830.WORKGROUP>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-03-05 at 10:14 -0800, Alison Schofield wrote:
> On Sun, Mar 05, 2017 at 12:17:21PM +0530, simran singhal wrote:
> > The function atomisp_set_stop_timeout on being called, simply returns
> > back. The function hasn't been mentioned in the TODO and doesn't have
> > FIXME code around. Hence, atomisp_set_stop_timeout and its calls have been
> > removed.
> > 
> > Signed-off-by: simran singhal <singhalsimran0@gmail.com>
> > ---
> 
> Hi Simran,
> 
> It's helpful to state right in the subject line what you removed.
> ie.  remove unused function atomisp_set_stop_timeout()
> 
> If you do that, scan's or grep'ing the git log pretty oneline's can 
> easily see this without having to dig into the log.
> 
> (gitpretty='git log --pretty=oneline --abbrev-commit')
> 
> Can you share to Outreachy group how you found this?  By inspection
> or otherwise??

At least for the rtl8192u patch submitted:

It's also helpful to read the comment you remove
and determine if what you are doing is the correct
thing to do and explain why it's OK in the commit
message. (fractured english below notwithstanding)

 /* These function were added to load crypte module autoly */
-       ieee80211_tkip_null();
 
