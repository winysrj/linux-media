Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab0KPSVj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 13:21:39 -0500
Message-ID: <4CE2C2F9.9010801@redhat.com>
Date: Tue, 16 Nov 2010 15:44:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] kconfig: add an option to determine a menu's visibility
References: <4CD300AC.3010708@redhat.com>	<1289079027-3037-2-git-send-email-lacombar@gmail.com> <AANLkTinwmSOSnQ6SsLy4ijXmocccX=o+iHh+9otfmAmN@mail.gmail.com>
In-Reply-To: <AANLkTinwmSOSnQ6SsLy4ijXmocccX=o+iHh+9otfmAmN@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-11-2010 14:57, Arnaud Lacombe escreveu:
> Hi all
> 
> On Sat, Nov 6, 2010 at 5:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> This option is aimed to add the possibility to control a menu's visibility
>> without adding dependency to the expression to all the submenu.
>>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>> ---
>>  scripts/kconfig/expr.h      |    1 +
>>  scripts/kconfig/lkc.h       |    1 +
>>  scripts/kconfig/menu.c      |   11 +++++++++++
>>  scripts/kconfig/zconf.gperf |    1 +
>>  scripts/kconfig/zconf.y     |   21 ++++++++++++++++++---
>>  5 files changed, 32 insertions(+), 3 deletions(-)
>>
> Michal, I don't think you commented on this ? Mauro, has it been
> worked around differently ?

Those patches worked fine, and solved all problems we had (I just had to touch
on two other menus that are used, as I answered upstream).

I prefer if Michal could forward those patches upstream, so, there's my ack:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Cheers,
Mauro
