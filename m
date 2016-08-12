Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36744 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbcHLGf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 02:35:26 -0400
Received: by mail-wm0-f47.google.com with SMTP id q128so10567248wma.1
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 23:35:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160811083652.55371952@lwn.net>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org> <20160811083652.55371952@lwn.net>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 12 Aug 2016 12:05:04 +0530
Message-ID: <CAO_48GEUzviZT0HMa8UhT+jN-eNmbTyTdnBs9SZFXz2fJ0m-7Q@mail.gmail.com>
Subject: Re: [RFC 0/4] doc: dma-buf: sphinx conversion and cleanup
To: Jonathan Corbet <corbet@lwn.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon!

On 11 August 2016 at 20:06, Jonathan Corbet <corbet@lwn.net> wrote:
> On Thu, 11 Aug 2016 16:17:56 +0530
> Sumit Semwal <sumit.semwal@linaro.org> wrote:
>
>> Convert dma-buf documentation over to sphinx; also cleanup to
>> address sphinx warnings.
>>
>> While at that, convert dma-buf-sharing.txt as well, and make it the
>> dma-buf API guide.
>
> Thanks for working to improve the documentation!  I do have a few overall
> comments...
>
Thank you for your review, and comments; my responses are inline.

>  - The two comment fixes are a separate thing that should go straight to
>    the dma-buf maintainer, who is ... <looks> ... evidently somebody
>    familiar to you :)  I assume you'll merge those two directly?
>
Yes, of course :) - I will merge them directly, and will remove them
from v2 of this series.

>  - It looks like you create a new RST document but leave the old one in
>    place.  Having two copies of the document around can only lead to
>    confusion, so I think the old one should go.
>
Agreed on this as well; will correct it.

>  - I really wonder if we want to start carving pieces out of
>    device-drivers.tmpl in this way.  I guess I would rather see the
>    conversion of that book and the better integration of the other docs
>    *into* it.  One of the goals of this whole thing is to unify our
>    documentation, not to reinforce the silos.
>
I should've mentioned it in the cover letter - my intention of taking
the dma-buf pieces out was to focus on these first while moving to
sphinx.

My proposal would be, if all the device driver section owners could
take the relevant pieces, convert them to sphinx (ironing out warnings
etc in the process), then we can again 'bind' them together into the
device drivers book in rst format.
This breaks the documentation conversion task into manageable pieces
that can be handled independently, and gives everyone flexibility to
work on their schedules.

This should also help in a good technical re-look at the content by
subsystem developers, and make any documentation updates as required.
The beauty of sphinx should allow us this, I think? Just my 2 cents.

> Does that make sense?
>
I do hope that my proposal above finds some merit with everyone.

> Thanks,
>
> jon

BR,
Sumit.
