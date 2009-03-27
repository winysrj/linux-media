Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:55743 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbZC0NIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 09:08:07 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1243850rvb.1
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 06:08:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090327070711.14dab3c9@pedra.chehab.org>
References: <15ed362e0903170900y6a71cb71oc65768367a8cfd14@mail.gmail.com>
	 <20090327070711.14dab3c9@pedra.chehab.org>
Date: Fri, 27 Mar 2009 21:08:04 +0800
Message-ID: <15ed362e0903270608h656fe3d4o11dd9799d8958268@mail.gmail.com>
Subject: Re: [PATCH] Remove stream pipe draining code for CXUSB D680 DMB
From: David Wong <davidtlwong@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 27, 2009 at 6:07 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Wed, 18 Mar 2009 00:00:10 +0800
> David Wong <davidtlwong@gmail.com> wrote:
>
>> CXUSB D680 DMB pipe draining code found to be problematic for new
>> kernels (eg. kernel 2.6.27 @ Ubuntu 8.10)
>
> Could you please provide a clearer description? Why is it problematic? Also,
> please don't test against a distro-patched kernel, but against vanilla kernel.
> Since the patch will appear after 2.6.29, you should test using 2.6.29.
>
> Cheers,
> Mauro
>

With that pipe draining code, the USB controller response is weird,
i2c doesn't work.
But Timothy Lee said he need that to drain the pipe after hibernate.
Seems some TS data remains in the pipe
that troubles mplayer.

Regards,
David
