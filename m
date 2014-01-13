Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40622 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaAMMsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 07:48:24 -0500
Received: by mail-ie0-f181.google.com with SMTP id at1so191249iec.40
        for <linux-media@vger.kernel.org>; Mon, 13 Jan 2014 04:48:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140113090208.0437013b@samsung.com>
References: <CAGfcS_=jvT5ExkkXiXjzmwR4DgXogM59rwrLhRMLeHe=LRAYjA@mail.gmail.com>
	<20140113090208.0437013b@samsung.com>
Date: Mon, 13 Jan 2014 07:48:24 -0500
Message-ID: <CAGfcS_kXyFgoFgpLx8d3_PFKc4mxYFvQhycTQ=18scTsXbyokg@mail.gmail.com>
Subject: Re: Issue with 3.12.5/7 and CX23880/1/2/3 DVB Card
From: Rich Freeman <rich0@gentoo.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 13, 2014 at 6:02 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Sun, 12 Jan 2014 16:26:41 -0500
> Rich Freeman <rich0@gentoo.org> escreveu:
>
>> I noticed that you authored commit
>> 19496d61f3962fd6470b106b779eddcdbe823c9b, which replaced a dynamic
>> buffer with a static one when sending data to the card.
>
> Can you please try the following patch?
>
> nxt200x: increase write buffer size

After applying your patch to 3.12.7 (from the git tag) the firmware
loads without any warnings, and the card operates normally.  I think
that did the trick.

Thanks for the prompt response!

Rich
