Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab1CVKPm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 06:15:42 -0400
Message-ID: <4D8876C5.6030802@redhat.com>
Date: Tue, 22 Mar 2011 07:15:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org
Subject: Re: S2-3200 switching-timeouts on 2.6.38
References: <4D87AB0F.4040908@t-online.de>	<20110321131602.36d146b1.rdunlap@xenotime.net>	<AANLkTik22=YE-2W4AtO9w_kVm=oro_YM7hJ52Rj83Fmt@mail.gmail.com> <8739mfwkfa.fsf@nemi.mork.no>
In-Reply-To: <8739mfwkfa.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-03-2011 06:53, Bjørn Mork escreveu:
> Manu Abraham <abraham.manu@gmail.com> writes:
>> On Tue, Mar 22, 2011 at 1:46 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>> On Mon, 21 Mar 2011 20:46:23 +0100 Rico Tzschichholz wrote:
>>>
>>>> Hello,
>>>>
>>>> I would like to know if there is any intention to include this patch
>>>> soon? https://patchwork.kernel.org/patch/244201/
>>>
>>> There are MANY posted but unmerged patches in patchwork from the linux-media
>>> mailing list.  What is going on (or not going on) with patch merging?
>>
>> Actually, quite a lot of effort was put in to get that part right. It
>> does the reverse thing that's to be done.
>> The revamped version is here [1] If the issue persists still, then it
>> needs to be investigated further.
>>
>> [1] http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg09214.html
> 
> So the patch state should be "Rejected" and not "Under Review".
> 
> Would certainly help us all if the patchwork state was updated whenever
> a patch actually was processed...

Yes, but the thing is that somebody needs to manually update me about status change,
as patchwork doesn't provide any way for it. Patchwork's permission for a project
is all or nothing: or you completely own a project, or you have just read-only
access. There's no way, currently, for me to delegate a patch to someone without
allowing that person to touch at the non-delegated patches. Also, patchwork
also doesn't allow me to change contributor status (there's just one global admin
that creates and/or modifies account access on patchwork).

Anyway, I've updated the status for #244201.

Thanks,
Mauro.
