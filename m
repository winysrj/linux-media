Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36476 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbcHQLCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 07:02:15 -0400
Received: by mail-io0-f193.google.com with SMTP id y34so9648592ioi.3
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2016 04:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D841D797-4EF0-4D32-BD74-6F675822C940@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
 <20160814120920.62098dae@lwn.net> <DCB8AFBC-2E5E-4CD0-97A0-9325686CE17F@darmarit.de>
 <20160816152243.17927afe@vento.lan> <D841D797-4EF0-4D32-BD74-6F675822C940@darmarit.de>
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Wed, 17 Aug 2016 13:02:13 +0200
Message-ID: <CAKMK7uE79Kgp4UWdiu4e0_Z1gp19f-X4NoL7FusZc9no5YV6TQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] doc-rst: sphinx sub-folders & parseheaders directive
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jani Nikula <jani.nikula@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 17, 2016 at 7:44 AM, Markus Heiser
<markus.heiser@darmarit.de> wrote:
>>>> - Along those lines, is parse-header the right name for this thing?
>>>> "Parsing" isn't necessarily the goal of somebody who uses this directive,
>>>> right?  They want to extract documentation information.  Can we come up
>>>> with a better name?
>>>
>>> Mauro, what is your suggestion and how would we go on in this topic?
>>
>> Maybe we could call it as: "include-c-code-block" or something similar.
>
> Hmm, that's not any better, IMHO ... there is a 'parsed-literal' so, what's
> wrong with a 'parsed-header' directive or for my sake ' parse-c-header'.
> IMHO it is very unspecific what this directive does and it might be changed in
> the near future if someone (e.g. Daniel [1]) see more use cases then the one yet.
>
> [1] https://www.mail-archive.com/linux-media%40vger.kernel.org/msg101129.html

I was wondering more whether we should uplift this to be the canonical
way to document uapi headers. Then we could call it kernel-uapi-header
or whatever, along the lines of our kernel-doc directive. But really
this was just an idea, atm it's a media exclusive feature of our doc
toolchain.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
