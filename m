Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52976 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZJWXen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 19:34:43 -0400
Received: by fxm18 with SMTP id 18so10753750fxm.37
        for <linux-media@vger.kernel.org>; Fri, 23 Oct 2009 16:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a3ef07920910231202l1c3861ddga223c22157ba5591@mail.gmail.com>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	 <20091023051025.597c05f4@caramujo.chehab.org>
	 <1a297b360910221329o4b832f4ewaee08872120bfea0@mail.gmail.com>
	 <a3ef07920910231202l1c3861ddga223c22157ba5591@mail.gmail.com>
Date: Sat, 24 Oct 2009 01:34:46 +0200
Message-ID: <d9def9db0910231634i4752875ds284010a73f82e341@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Markus Rechberger <mrechberger@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 23, 2009 at 9:02 PM, VDR User <user.vdr@gmail.com> wrote:
> On Thu, Oct 22, 2009 at 1:29 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Sometime back, (some time in April) i proposed a patch which addressed
>> the issue to scale "even those devices which have a weird scale or
>> none". Though based on an older tree of mine, here is the patch again.
>> If it looks good enough, i can port the patch to accomodate other
>> devices as well.
>
> Thanks for posting your patch.  How about people get some discussion
> going about the pros/cons instead of ignoring it?  The best method for
> the most devices needs to be the deciding factor here, not
> accepting/disregarding based on who "your" friends are.  For once it
> would be nice if the childish politics could get throw out and what's
> best for v4l be the highest priority.
>
> And a thanks to anyone else that would like to submit a recommendation
> on how to deal with this.  Hopefully there will be a few "solid"
> proposals to consider.
>

it would be good to have a table what statistics can be returned, obviously
the API implementation doesn't matter so much.

Manu, Mike can you start a wiki site on linuxtv.org addressing this topic?
Please work out a proper API definition first, afterwards think about
the implementation.

The correct implementation in the enduser applications is by far more important.

Best Regards,
Markus
