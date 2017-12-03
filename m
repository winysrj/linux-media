Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37539 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdLCPEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Dec 2017 10:04:34 -0500
Received: by mail-wr0-f193.google.com with SMTP id k61so14609044wrc.4
        for <linux-media@vger.kernel.org>; Sun, 03 Dec 2017 07:04:34 -0800 (PST)
Subject: Re: [GIT PULL] SAA716x DVB driver
To: Soeren Moch <smoch@web.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: =?UTF-8?Q?Tycho_L=c3=bcrsen?= <tycholursen@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Manu Abraham <manu@linuxtv.org>,
        Andreas Regel <andreas.regel@gmx.de>,
        Oliver Endriss <o.endriss@gmx.de>
References: <50e5ba3c-4e32-f2e4-7844-150eefdf71b5@web.de>
 <d693cf1b-de3d-5994-5ef0-eeb0e37065a3@web.de>
 <20170827073040.6e96d79a@vento.lan>
 <e9d87f55-18fc-e57b-f9aa-a41c7f983b34@web.de>
 <20170909181123.392cfbb0@vento.lan>
 <a44b8eb0-cdd5-aa28-ad30-68db0126b6f6@web.de>
 <20170916125042.78c4abad@recife.lan>
 <fab215f8-29f3-1857-6f33-c45e78bb5e3c@web.de>
 <7c17c0a1-1c98-1272-8430-4a194b658872@gmail.com>
 <20171127092408.20de0fe0@vento.lan>
 <e2076533-5c33-f3be-b438-a1616f743a92@gmail.com>
 <20171202174922.34a6f9b9@vento.lan>
 <ce4f25e6-7d75-2391-d685-35b50a0639bb@web.de>
 <335e279e-d498-135f-8077-770c77cf353b@gmail.com>
 <3251f1f3-ce9b-529d-b155-ac433d1b0ae5@web.de>
From: Jemma Denson <jdenson@gmail.com>
Message-ID: <740078a3-ce40-c16d-79dd-5e55c5496060@gmail.com>
Date: Sun, 3 Dec 2017 15:04:31 +0000
MIME-Version: 1.0
In-Reply-To: <3251f1f3-ce9b-529d-b155-ac433d1b0ae5@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/17 14:11, Soeren Moch wrote:
> On 03.12.2017 11:57, Jemma Denson wrote:
>> On 02/12/17 23:59, Soeren Moch wrote:
>>> All the entries in the TODO file are not specific for saa716x_ff.
>> Ah, it's been a few months since I looked at that. I think some of the
>> things listed I had already identified as problems - checkpatch
>> especially,
> Finding checkpatch problems is easy...

Indeed they are. They still take some time to go though.

>> Hence my comment about finding a maintainer - I had assumed if the
>> immediate result didn't support your card you probably wouldn't be
>> willing
>> to do that.
>>
>> What I'm trying to do here is get *something* merged, and then once
>> that work is done any interested parties can add to it. Or at the very
>> least if some patches are left OOT the constant workload required to
>> keep that up to date should be reduced significantly because they'll be
>> far less to look after.
>>
> Why not merge the driver as-is? The community would get support for
> several cards, easy access to the code without the need for separate git
> repositories or dkms packages, and a maintainer that understands the
> hardware and driver code.
>
> The whole purpose of driver development is bringing support for existing
> hardware to available user applications, preferably with existing APIs.
> And exactly that is in this pull request.
> In the whole discussion I cannot find a single reason, how merging this
> driver would violate the linux development principles.

That's not really one for me to answer, but Mauro has raised objections
so it can't be merged as is. I'm just trying to find a way forward that
avoids this getting stuck for another few years.

>> One of the problems though is choosing which fork to use. I *think* there
>> are 2 - the one you've got which is the original powARman branch and the
>> one I would be using is the CrazyCat / Luis /  TBS line. There are
>> going to be
>> some differences but hopefully that's all frontend support based and
>> one cut
>> down to a single frontend would end up a good base to add the rest back
>> in.
>>
> I think my repository represents the main development branch, just
> maintained by different people (adding Manu, Andreas, Oliver, in case
> they want to object). The CrazyCat repo is not a fork (including
> history), it is just a snapshot of the driver plus several patches.
>

Well I know of several patches I've made to that repo that haven't
made it back to the "main" branch, so whilst maybe not a fork in
the traditional sense it certainly is functioning like one.

As I said, I'm just trying to get *something* merged.  I can base a
ff-stripped patch on the powarman branch instead but it does represent
more work for me as I need to work out what else might be missing to
support the only card I have for testing this with. It might end up being
easy but I don't know that yet.

Let's get something happening here rather than just trying to argue
with the maintainers. There's absolutely nothing stopping further patches
being sent in later on once the chipset driver is merged.


Jemma.
