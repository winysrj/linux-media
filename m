Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab0KOQ5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 11:57:23 -0500
MIME-Version: 1.0
In-Reply-To: <1289079027-3037-2-git-send-email-lacombar@gmail.com>
References: <4CD300AC.3010708@redhat.com>
	<1289079027-3037-2-git-send-email-lacombar@gmail.com>
Date: Mon, 15 Nov 2010 11:57:22 -0500
Message-ID: <AANLkTinwmSOSnQ6SsLy4ijXmocccX=o+iHh+9otfmAmN@mail.gmail.com>
Subject: Re: [PATCH 1/5] kconfig: add an option to determine a menu's visibility
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all

On Sat, Nov 6, 2010 at 5:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> This option is aimed to add the possibility to control a menu's visibility
> without adding dependency to the expression to all the submenu.
>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  scripts/kconfig/expr.h      |    1 +
>  scripts/kconfig/lkc.h       |    1 +
>  scripts/kconfig/menu.c      |   11 +++++++++++
>  scripts/kconfig/zconf.gperf |    1 +
>  scripts/kconfig/zconf.y     |   21 ++++++++++++++++++---
>  5 files changed, 32 insertions(+), 3 deletions(-)
>
Michal, I don't think you commented on this ? Mauro, has it been
worked around differently ?

Thanks,
 - Arnaud
