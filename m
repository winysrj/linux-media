Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49367 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2FSMqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 08:46:30 -0400
Received: by ghrr11 with SMTP id r11so4542605ghr.19
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 05:46:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FDFA528.5020203@redhat.com>
References: <1338385364-2308-1-git-send-email-elezegarcia@gmail.com>
	<4FC718CD.8020503@googlemail.com>
	<CALF0-+WpXzJi7Nh4yyjn-AToxFH04femQRf910J9PHNvqqex4Q@mail.gmail.com>
	<4FDFA528.5020203@redhat.com>
Date: Tue, 19 Jun 2012 09:46:29 -0300
Message-ID: <CALF0-+Wq=_5sCjFn1w2+=sATd6M97WdV3JX0nPvRAMWswiAgeg@mail.gmail.com>
Subject: Re: [v4l-utils] Add configure option to allow qv4l2 disable
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gregor Jasny <gjasny@googlemail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Jun 18, 2012 at 7:01 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 31-05-2012 13:29, Ezequiel Garcia escreveu:
>> Hi Gregor,
>>
>> On Thu, May 31, 2012 at 4:07 AM, Gregor Jasny <gjasny@googlemail.com> wrote:
>>> Hello,
>>>
>>>
>>> On 5/30/12 3:42 PM, Ezequiel Garcia wrote:
>>>>
>>>> This patch could ease the job of a few people,
>>>> by providing an option they actually need.
>>>> OpenWRT [1] and Openembedded [2] are already disabling
>>>> qv4l2 by applying ugly patches.
>>>>
>>>> [1]
>>>> https://dev.openwrt.org/browser/packages/libs/libv4l/patches/004-disable-qv4l2.patch
>>>> [2] http://patches.openembedded.org/patch/21469/
>>>
>>>
>>> What's the purpose of this patch? As far as I can see it saves compile time
>>> if Qt4 development stuff is installed. Otherwise building qv4l should be
>>> skipped.
>>
>> I just found that people were applying patches to disable qv4l2 compilation.
>> In [2] you'll find this message: "The makefiles in the project attempt
>> to use the hosts' compilers if
>> qmake is installed." Perhaps, this was due to an old bug that's already solved.
>>
>> So: I'm not sure if patch is useful, but I thought I could send it
>> anyway and let you decide ;)
>
> Yeah, compiling qv4l2 on embedded distros may be hard.
> I'll apply it.
>

Gregory already applied this patch, and it seems you have now
over applied it in the same tree:

http://git.linuxtv.org/v4l-utils.git/commit/7fc9fa40e7fd1a72688c6f43fc11e085079b3f0c

http://git.linuxtv.org/v4l-utils.git/commit/06e5235b4e1514f9234a21942261ba417deb106c

Also Gregory cleaned a bit the patch
(mine was very basic, since I'm not autoconf-friendly).

So, could you revert the one you've committed?

Thanks,
Ezequiel.
