Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56833 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab0KPVlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 16:41:07 -0500
MIME-Version: 1.0
In-Reply-To: <4CE2C2F9.9010801@redhat.com>
References: <4CD300AC.3010708@redhat.com>
	<1289079027-3037-2-git-send-email-lacombar@gmail.com>
	<AANLkTinwmSOSnQ6SsLy4ijXmocccX=o+iHh+9otfmAmN@mail.gmail.com>
	<4CE2C2F9.9010801@redhat.com>
Date: Tue, 16 Nov 2010 16:41:06 -0500
Message-ID: <AANLkTim6VNvSTWOC_jZR09ktRaKUFaGorPz-cpS5bG7C@mail.gmail.com>
Subject: Re: [PATCH 1/5] kconfig: add an option to determine a menu's visibility
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Tue, Nov 16, 2010 at 12:44 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 15-11-2010 14:57, Arnaud Lacombe escreveu:
>> Hi all
>>
>> On Sat, Nov 6, 2010 at 5:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> This option is aimed to add the possibility to control a menu's visibility
>>> without adding dependency to the expression to all the submenu.
>>>
>>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>>> ---
>>>  scripts/kconfig/expr.h      |    1 +
>>>  scripts/kconfig/lkc.h       |    1 +
>>>  scripts/kconfig/menu.c      |   11 +++++++++++
>>>  scripts/kconfig/zconf.gperf |    1 +
>>>  scripts/kconfig/zconf.y     |   21 ++++++++++++++++++---
>>>  5 files changed, 32 insertions(+), 3 deletions(-)
>>>
>> Michal, I don't think you commented on this ? Mauro, has it been
>> worked around differently ?
>
> Those patches worked fine, and solved all problems we had (I just had to touch
> on two other menus that are used, as I answered upstream).
>
> I prefer if Michal could forward those patches upstream, so, there's my ack:
>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
It would seem Michal is not around lately, his only passage on
linux-kbuild@ is nearly a week old.

Sam, by any chance, could you comment on these patches so that we
could keep moving forward ?

Thanks,
 - Arnaud

ps: yes, I know, I did not upgrade the documentation.
