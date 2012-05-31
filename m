Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63730 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2EaQ3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 12:29:01 -0400
Received: by obbtb18 with SMTP id tb18so1545040obb.19
        for <linux-media@vger.kernel.org>; Thu, 31 May 2012 09:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC718CD.8020503@googlemail.com>
References: <1338385364-2308-1-git-send-email-elezegarcia@gmail.com>
	<4FC718CD.8020503@googlemail.com>
Date: Thu, 31 May 2012 13:29:00 -0300
Message-ID: <CALF0-+WpXzJi7Nh4yyjn-AToxFH04femQRf910J9PHNvqqex4Q@mail.gmail.com>
Subject: Re: [v4l-utils] Add configure option to allow qv4l2 disable
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

On Thu, May 31, 2012 at 4:07 AM, Gregor Jasny <gjasny@googlemail.com> wrote:
> Hello,
>
>
> On 5/30/12 3:42 PM, Ezequiel Garcia wrote:
>>
>> This patch could ease the job of a few people,
>> by providing an option they actually need.
>> OpenWRT [1] and Openembedded [2] are already disabling
>> qv4l2 by applying ugly patches.
>>
>> [1]
>> https://dev.openwrt.org/browser/packages/libs/libv4l/patches/004-disable-qv4l2.patch
>> [2] http://patches.openembedded.org/patch/21469/
>
>
> What's the purpose of this patch? As far as I can see it saves compile time
> if Qt4 development stuff is installed. Otherwise building qv4l should be
> skipped.

I just found that people were applying patches to disable qv4l2 compilation.
In [2] you'll find this message: "The makefiles in the project attempt
to use the hosts' compilers if
qmake is installed." Perhaps, this was due to an old bug that's already solved.

So: I'm not sure if patch is useful, but I thought I could send it
anyway and let you decide ;)

Hope it helps,
Ezequiel.
