Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab2FRWBR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 18:01:17 -0400
Message-ID: <4FDFA528.5020203@redhat.com>
Date: Mon, 18 Jun 2012 19:01:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Gregor Jasny <gjasny@googlemail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [v4l-utils] Add configure option to allow qv4l2 disable
References: <1338385364-2308-1-git-send-email-elezegarcia@gmail.com> <4FC718CD.8020503@googlemail.com> <CALF0-+WpXzJi7Nh4yyjn-AToxFH04femQRf910J9PHNvqqex4Q@mail.gmail.com>
In-Reply-To: <CALF0-+WpXzJi7Nh4yyjn-AToxFH04femQRf910J9PHNvqqex4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 31-05-2012 13:29, Ezequiel Garcia escreveu:
> Hi Gregor,
> 
> On Thu, May 31, 2012 at 4:07 AM, Gregor Jasny <gjasny@googlemail.com> wrote:
>> Hello,
>>
>>
>> On 5/30/12 3:42 PM, Ezequiel Garcia wrote:
>>>
>>> This patch could ease the job of a few people,
>>> by providing an option they actually need.
>>> OpenWRT [1] and Openembedded [2] are already disabling
>>> qv4l2 by applying ugly patches.
>>>
>>> [1]
>>> https://dev.openwrt.org/browser/packages/libs/libv4l/patches/004-disable-qv4l2.patch
>>> [2] http://patches.openembedded.org/patch/21469/
>>
>>
>> What's the purpose of this patch? As far as I can see it saves compile time
>> if Qt4 development stuff is installed. Otherwise building qv4l should be
>> skipped.
> 
> I just found that people were applying patches to disable qv4l2 compilation.
> In [2] you'll find this message: "The makefiles in the project attempt
> to use the hosts' compilers if
> qmake is installed." Perhaps, this was due to an old bug that's already solved.
> 
> So: I'm not sure if patch is useful, but I thought I could send it
> anyway and let you decide ;)

Yeah, compiling qv4l2 on embedded distros may be hard.
I'll apply it.

Regards,
Mauro
