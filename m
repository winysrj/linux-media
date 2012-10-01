Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63705 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab2JAOFP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 10:05:15 -0400
Received: by ieak13 with SMTP id k13so12141312iea.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 07:05:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50699C23.5000203@redhat.com>
References: <5034991F.5040403@samsung.com>
	<506967F1.7040308@samsung.com>
	<50698393.3080908@iki.fi>
	<50699C23.5000203@redhat.com>
Date: Mon, 1 Oct 2012 11:05:15 -0300
Message-ID: <CALF0-+W=xRO0G9gz1oSGyDbL0JHTYmPUU11qCpaK7BXJwGFBYw@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR v3.6] Samsung media driver fixes
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro and folks,

On Mon, Oct 1, 2012 at 10:35 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Anti/Sylwester,
>
> Em 01-10-2012 08:50, Antti Palosaari escreveu:
>> Hello
>> I have had similar problems too. We need badly find out better procedures for patch handling. Something like parches are updated about once per week to the master. I have found I lose quite much time rebasing and res-sending stuff all the time.
>>
>> What I propose:
>> 1) module maintainers sends all patches to the ML with some tag marking it will pull requested later. I used lately [PATCH RFC]
>> 2) module maintainer will pick up all the "random" patches and pull request those. There is no way to mark patch as handled in patchwork....
>> 3) PULL request are handled more often, like during one week or maximum two
>
> Yes, for sure we need to improve the workflow. After the return from KS,
> I found ~400 patches/pull requests on my queue. I'm working hard to get rid
> of that backlog, but still there are ~270 patches/pull requests on my
> queue today.
>
> The thing is that patches come on a high rate at the ML, and there's no
> obvious way to discover what patches are just the normal patch review
> discussions (e. g. RFC) and what are real patches.
>
> To make things worse, we have nowadays 494 drivers. A very few of those
> have an entry at MAINTAINERS, or a maintainer that care enough about
> his drivers to handle patches sent to the mailing list (even the trivial
> ones).
>
> Due to the missing MAINTAINERS entries, all patches go through the ML directly,
> instead of going through the driver maintainer.
>
> So, I need to manually review every single email that looks to have a patch
> inside, typically forwarding it to the driver maintainer, when it exists,
> handling them myself otherwise.
>
> I'm counting with our discussions at the Barcelona's mini-summit in order
> to be able to get fresh ideas and discuss some alternatives to improve
> the patch workflow, but there are several things that could be done already,
> like the ones you've proposed, and keeping the MAINTAINERS file updated.
>

Perhaps I'm missing something but I don't think there's an obvious
solution for this,
unless more maintainers are willing to start providing reviews / tests
/ acks / etc.
for patches that arrive.

Seems to me media/ has become a truly large subsystem,
though I'm not sure how does it compare to others subsystems.
Has anyone thought about breaking media/ down into smaller sub-subsystems,
with respective sub-maintainer?

I'm not really sure if this should improve or worsen Mauro's rate.

Just my two cents,
Ezequiel.
