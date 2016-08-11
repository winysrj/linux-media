Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38075 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcHKMbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 08:31:48 -0400
Received: by mail-wm0-f53.google.com with SMTP id o80so12904051wme.1
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 05:31:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87twerv86p.fsf@intel.com>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
 <1470912480-32304-4-git-send-email-sumit.semwal@linaro.org> <87twerv86p.fsf@intel.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 11 Aug 2016 18:01:25 +0530
Message-ID: <CAO_48GHSFkOjtV0EaAmP_aU9U3AQU62=QPTdopNOfE2v+vSSRg@mail.gmail.com>
Subject: Re: [RFC 3/4] Documentation: move dma-buf documentation to rst
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	corbet@lwn.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jani,

On 11 August 2016 at 17:17, Jani Nikula <jani.nikula@linux.intel.com> wrote:
> On Thu, 11 Aug 2016, Sumit Semwal <sumit.semwal@linaro.org> wrote:
>> diff --git a/Documentation/dma-buf/guide.rst b/Documentation/dma-buf/guide.rst
>> new file mode 100644
>> index 000000000000..fd3534fdccb3
>> --- /dev/null
>> +++ b/Documentation/dma-buf/guide.rst
>> @@ -0,0 +1,503 @@
>> +
>> +.. _dma-buf-guide:
>> +
>> +============================
>> +DMA Buffer Sharing API Guide
>> +============================
>> +
>> +Sumit Semwal - sumit.semwal@linaro.org, sumits@kernel.org
>
> Please use the format
>
> :author: Sumit Semwal <sumit.semwal@linaro.org>
>
Thanks very much for reviewing!
> ---
>
> While on this subject, please excuse me for hijacking the thread a bit.
>
> Personally, I believe it would be better to leave out authorship notes
> from documentation and source files in collaborative projects. Of
> course, it is only fair that people who deserve credit get the
> credit. Listing the authors in the file is often the natural thing to
> do, and superficially seems fair.
>
> However, when do you add more names to the list? When has someone
> contributed enough to warrant that? Is it fair that the original authors
> keep getting the credit for the contributions of others? After a while,
> perhaps there is next to nothing left of the original contributions, but
> the bar is really high for removing anyone from the authors. Listing the
> authors gives the impression this is *their* file, while everyone should
> feel welcome to contribute, and everyone who contributes should feel
> ownership.
>
> IMHO we would be better off using just the git history for the credits.
>
:) - I totally agree with your stand; this patch was an (almost)
direct conversion from the earlier format, hence this patch.

But yes, I will remove it in the next iteration.
>
> BR,
> Jani.
>
>
BR,
Sumit.

> PS. I am no saint here, I've got a couple of authors lines myself. I
> promise not to add more. I certainly won't chastise anyone for adding
> theirs.
>
>
> --
> Jani Nikula, Intel Open Source Technology Center



-- 
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org │ Open source software for ARM SoCs
