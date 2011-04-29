Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47407 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1D2QfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 12:35:01 -0400
Received: by qwk3 with SMTP id 3so1794223qwk.19
        for <linux-media@vger.kernel.org>; Fri, 29 Apr 2011 09:35:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DBAB466.4040404@redhat.com>
References: <20110221214906.GA27284@mess.org>
	<4DBAB466.4040404@redhat.com>
Date: Fri, 29 Apr 2011 09:35:00 -0700
Message-ID: <BANLkTi=F34BRES29NPWLitbe6yUNsFK=OA@mail.gmail.com>
Subject: Re: [PATCH] DVB USB should not depend on RC
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Apr 29, 2011 at 5:51 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi Sean,
>
> Em 21-02-2011 18:49, Sean Young escreveu:
>> I have a SheevaPlug which has no (human) input or output devices, with a
>> DVB USB device connected with a mythtv backend running. The DVB USB drivers
>> pull in the remote control tree, which is unneeded in this case; the
>> mythtv client runs elsewhere (where RC is used). However the RC tree depends
>> on input which also has dependants.
>>
>> This can save a reasonable amount of memory:
>>
>>  $ ./scripts/bloat-o-meter vmlinux vmlinux-no-rc add/remove: 0/909 grow/shrink: 1/20 up/down: 4/-159171 (-159167)
>
> Sorry for a late review. The problem with this patch is that it is too much intrusive.
> It is a bad practice to fill the code with lots of #ifdef's, because it makes harder
> to analyse the source code and find bugs there.
>
> Also, while it saves some memory, this strategy forces that all DVB drivers to have a
> check for RC_CORE, being very easy that someone would forget about that, causing compilation
> breakages if this option is disabled.
>
> The proper way is to have a separate module for RC and just making such module as dependent
> of RC_CORE.

Sean, could you possibly rework your patch in accordance with what
Mauro stated above?
