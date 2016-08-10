Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36782 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933051AbcHJTnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 15:43:16 -0400
Received: by mail-it0-f45.google.com with SMTP id x130so47250518ite.1
        for <linux-media@vger.kernel.org>; Wed, 10 Aug 2016 12:43:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mvklvvbd.fsf@intel.com>
References: <8760rbp8zh.fsf@intel.com> <6D7865EB-9C40-4B8F-8D8F-3B28024624F3@darmarit.de>
 <87mvklvvbd.fsf@intel.com>
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Wed, 10 Aug 2016 14:24:58 +0200
Message-ID: <CAKMK7uGb1tWnWVqbKt3yATKVM-iWn9z8+wzV9=TF-3DowsaKTg@mail.gmail.com>
Subject: Re: parts of media docs sphinx re-building every time?
To: Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 10, 2016 at 11:15 AM, Jani Nikula <jani.nikula@intel.com> wrote:
> On Mon, 08 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>> Hi Jani,
>>
>> Am 08.08.2016 um 17:37 schrieb Jani Nikula <jani.nikula@intel.com>:
>>
>>>
>>> Hi Mauro & co -
>>>
>>> I just noticed running 'make htmldocs' rebuilds parts of media docs
>>> every time on repeated runs. This shouldn't happen. Please investigate.
>>>
>>> I wonder if it's related to Documentation/media/Makefile... which I have
>>> to say I am not impressed by. I was really hoping we could build all the
>>> documentation by standalone sphinx-build invocation too, relying only on
>>> the conf.py so that e.g. Read the Docs can build the docs. Part of that
>>> motivation was to keep the build clean in makefiles, and handing the
>>> dependency tracking completely to Sphinx.
>>>
>>> I believe what's in Documentation/media/Makefile,
>>> Documentation/sphinx/parse-headers.pl, and
>>> Documentation/sphinx/kernel_include.py could be replaced by a Sphinx
>>> extension looking at the sources directly.
>>
>> Yes, parse-headers.pl, kernel_include.py and media/Makefile are needed
>> for one feature ... not very straight forward.
>>
>> If it makes sense to migrate the perl scripts functionality to a
>> Sphinx extension, may I can help ... depends on what Mauro thinks.
>>
>> BTW: parse-headers.pl is not the only perl script I like to migrate to py ;)
>
> If I understand the need of all of this right, I think the cleanest and
> fastest short term measure would be to make the kernel-include directive
> extension do the same thing as the kernel-doc directive does: call the
> perl script from the directive.
>
> This lets you get rid of Documentation/media/Makefile and you don't have
> to copy-paste all of Include.run method into kernel_include.py. You can
> also get rid of specifying environment variables in rst files and
> parsing them in the extension. We can get rid of the problematic
> intermediate rst files. This design has been proven with the kernel-doc
> extension and script already. It's much simpler.

I looked a bit at this and seems interesting ... a few questions:
- Are you using this just for uapi headers or also for other bits?
- My concern with out-of-line docs is always that people forget to
update them. How do you enforce that in the media subsystem?
- Atm we don't have any formal way to document drm ioctl, and this
could be a possible approach. Would it be possible to share this with
other subsystems, maybe extended/polished, perhaps even as the
official way to document uapi headers?

Just some thoughts, orthogonal to the discussion at hand here.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
