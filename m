Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38811 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbHYWcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 18:32:21 -0400
Received: by igfj19 with SMTP id j19so23140271igf.1
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2015 15:32:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150825071058.29bcc207@recife.lan>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<5ccb3df9166af331070f546a7d3c522d65964919.1440359643.git.mchehab@osg.samsung.com>
	<55DC1501.5000208@xs4all.nl>
	<20150825071058.29bcc207@recife.lan>
Date: Tue, 25 Aug 2015 16:32:19 -0600
Message-ID: <CAKocOOOsd66roTdJSf6qUmn49Lc7ARqxMEKPGA_LAvfXcowL5g@mail.gmail.com>
Subject: Re: [PATCH v7 15/44] [media] media: get rid of an unused code
From: Shuah Khan <shuahkhan@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	shuahkh@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 25, 2015 at 4:10 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Tue, 25 Aug 2015 09:10:57 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>
>> On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
>> > This code is not used in practice. Get rid of it before
>> > start converting links to lists.
>>
>> I assume the reason is that links are always created *after*
>> entities are registered?
>
> That was the assumption. However, Javier found some cases where drivers
> are creating links before.
>
> So, we should either drop this patch and add some additional logic
> on the next one to handle late graph object init or to fix the
> drivers before.
>
> I'll work on the delayed graph object init, as it sounds the
> easiest way, but let's see how such change will actually work.
>

I think we should drop this patch for now. I also would like to see
this new code
in action on a driver that has DVB and V4L modules and creates entities during
probe and maybe even links during probe with no specific probe ordering between
individual module probes. This way we are sure we need this code and know that
it is correct.

thanks,
-- Shuah
