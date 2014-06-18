Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:54772 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966540AbaFRNXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jun 2014 09:23:23 -0400
Date: Wed, 18 Jun 2014 15:23:09 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, Gregor Jasny <gjasny@googlemail.com>
Subject: Re: [PATCH RESEND] libv4lconvert: Fix a regression when converting
 from Y10B
Message-Id: <20140618152309.d16b3e703dc77fa9ca3551a8@ao2.it>
In-Reply-To: <53A17C02.1080702@redhat.com>
References: <20140603155930.f72e14f4aab39ec49bdb1b71@ao2.it>
	<1402930841-14755-1-git-send-email-ao2@ao2.it>
	<53A17B4C.3010005@redhat.com>
	<53A17C02.1080702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Jun 2014 13:46:10 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> On 06/18/2014 01:43 PM, Hans de Goede wrote:
> > Hi,
> > 
> > On 06/16/2014 05:00 PM, Antonio Ospite wrote:
> >> Fix a regression introduced in commit
> >> efc29f1764a30808ebf7b3e1d9bfa27b909bf641 (libv4lconvert: Reject too
> >> short source buffer before accessing it).
> >>
> >> The old code:
> >>
> >> case V4L2_PIX_FMT_Y10BPACK:
> >> 	...
> >> 	if (result == 0 && src_size < (width * height * 10 / 8)) {
> >> 		V4LCONVERT_ERR("short y10b data frame\n");
> >> 		errno = EPIPE;
> >> 		result = -1;
> >> 	}
> >> 	...
> >>
> >> meant to say "If the conversion was *successful* _but_ the frame size
> >> was invalid, then take the error path", but in
> >> efc29f1764a30808ebf7b3e1d9bfa27b909bf641 this (maybe weird) logic was
> >> misunderstood and v4lconvert_convert_pixfmt() was made to return an
> >> error even in the case of a successful conversion from Y10B.
> >>
> >> Fix the check, and now print only the message letting the errno and the
> >> result from the conversion routines to be propagated to the caller.
> >>
> >> Signed-off-by: Antonio Ospite <ao2@ao2.it>
> >> Cc: Gregor Jasny <gjasny@googlemail.com>
> > 
> > Thanks for the patch, but: ...
> > 
> >> ---
> >>  lib/libv4lconvert/libv4lconvert.c | 5 +----
> >>  1 file changed, 1 insertion(+), 4 deletions(-)
> >>
> >> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
> >> index c49d30d..50d6906 100644
> >> --- a/lib/libv4lconvert/libv4lconvert.c
> >> +++ b/lib/libv4lconvert/libv4lconvert.c
> >> @@ -1052,11 +1052,8 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
> >>  							   width, height);
> >>  			break;
> >>  		}
> >> -		if (result == 0) {
> >> +		if (result != 0)
> >>  			V4LCONVERT_ERR("y10b conversion failed\n");
> >> -			errno = EPIPE;
> >> -			result = -1;
> >> -		}
> >>  		break;
> >>  
> >>  	case V4L2_PIX_FMT_RGB565:
> > 
> > Why print a message here at all in the != 0 case? In the old code before commit
> > efc29f1764 you did not print an error when v4lconvert_y10b_to_... failed, so
> > I assume that that already does a V4LCONVERT_ERR in that case. So why do it a
> > second time with a less precise error message here?
> >

The one from v4lconvert_oom_error(), yes, which is generic, it does not
tell _where_ the failure was.
 
> > So I believe that the proper fix would be to just remove the entire block instead
> > of flipping the test and keeping the V4LCONVERT_ERR. Please send a new version
> > with this fixed, then I'll merge it asap.
> 
> Scrap that, I decided I might just as well fix this bit myself, so I've just
> pushed an updated patch completely removing the second check from the
> V4L2_PIX_FMT_Y10BPACK case.
> 

The rationale behind leaving the message was:
  1. The conversion routines are called even in the case of short
     frames (BTW that is true for any format, not just for Y10B).
  2. The conversion routines from Y10B are not "in place", they
     allocate a temporary buffer, so they may fail themselves.

with this in mind I saw the second message as an _additional_ error
indication to the user (useful in case of short frame _and_ conversion
failure) rather than a less precise one. However, you are right that
this additional error message was not in the original code before
efc29f1764, so your patch is perfectly fine by me.

Thanks for merging it.

BTW, comments about 1.?
What's the idea behind calling the conversion routines even for short
frames?

Ciao ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
