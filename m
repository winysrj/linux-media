Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40754 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2LKUlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 15:41:06 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1844641bkw.19
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 12:41:05 -0800 (PST)
Message-ID: <50C79A6D.9010008@googlemail.com>
Date: Tue, 11 Dec 2012 21:41:17 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: First draft of guidelines for submitting patches to linux-media
References: <201212101407.09338.hverkuil@xs4all.nl> <50C60620.2010603@googlemail.com> <201212101727.29074.hverkuil@xs4all.nl> <20121210153816.0d4d9b64@redhat.com> <50C63543.8020500@googlemail.com> <20121210174036.03dd521c@redhat.com>
In-Reply-To: <20121210174036.03dd521c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.12.2012 20:40, schrieb Mauro Carvalho Chehab:

[snip]

>> And people beeing subsystem maintainers AND driver maintainers have to
>> find a balance between processing pull requests and reviewing patches.
>> I'm not sure if I have understood yet how this balance should look
>> like... Can you elaborate a bit on this ?
>> At the moment it's ~12 weeks / ~2 weeks. What's the target value ? ;)
> Please wait for it to be implemented before complaining it ;) The 
> sub-maintainers new schema will start to work likely by Feb/Mar 2013.

I don't want to complain (yet ;) ). I'm just trying to understand what
is supposed to reduce the review times...
Haven't succeeded yet, because the same amount work seems to be
redivided among the same amount of maintainer/reviewer resources (=people).

Anyway, I will be patient and hope that things will evolve as planed.
I will also try to test and/or review patches from other if possible.

[snip]

>> So who can get an account / is supposed to access patchwork ?
>> - subsystem maintainers ?
>> - driver maintainers ?
>> - patch creators ?
> Subsystem maintainers only, except if someone can fix patchwork, adding
> proper ACL's there to allow patch creators to manage their own patches
> and sub-system maintainers to delegate work to driver maintainers, without
> giving them full rights, and being notified about status changes on
> those driver's patches.

Ok, thanks, I think this should be mentioned in the document.

Regards,
Frank


