Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53607 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758734Ab2AFOzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 09:55:22 -0500
Received: by eekc4 with SMTP id c4so1105900eek.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 06:55:21 -0800 (PST)
Message-ID: <4F070B55.4080408@gmail.com>
Date: Fri, 06 Jan 2012 15:55:17 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH FOR 3.3] VIDIOC_LOG_STATUS support for sub-devices
References: <4EFEEEB7.2020109@gmail.com> <4F07075E.8050301@redhat.com>
In-Reply-To: <4F07075E.8050301@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2012 03:38 PM, Mauro Carvalho Chehab wrote:
> On 31-12-2011 09:15, Sylwester Nawrocki wrote:
>> Hi Mauro,
>>
>> The following changes since commit 3220eb73c5647af4c1f18e32c12dccb8adbac59d:
>>
>>    s5p-fimc: Add support for alpha component configuration (2011-12-20 19:46:55
>> +0100)
>>
>> are available in the git repository at:
>>    git://git.infradead.org/users/kmpark/linux-samsung v4l_mbus
>>
>> This one patch enables VIDIOC_LOG_STATUS on subdev nodes.
>>
>> Sylwester Nawrocki (1):
>>        v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes
>
>
> Weird... when trying to pull from your tree, several other patches appeared.
> After removing the ones that seemed to be already applied, there are still
> those that seemed to still apply:
>
> Nov,17 2011: s5p-fimc: Prevent lock up caused by incomplete H/W initialization

This one was already requested in my previous pull request:
http://patchwork.linuxtv.org/patch/8765/

> Oct, 1 2011: v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes

and this is the only one new I'd like you to apply for 3.3.

> Dec, 9 2011: v4l: Add new framesamples field to struct v4l2_mbus_framefmt
> Dec,15 2011: v4l: Update subdev drivers to handle framesamples parameter
> Dec,12 2011: m5mols: Add buffer size configuration support for compressed streams
> Nov,21 2011: s5p-fimc: Add media bus framesamples support

These are irrelevant and should be dropped. Sorry for the confusion, 
I've sent this pull request when I didn't have write access to the
git://git.infradead.org/users/kmpark/linux-samsung repository.

>
> Could you please double-check and, if possible, rebase your tree, to avoid
> the risk of applying something that is not ok yet, nor to miss something?

Unfortunately I can't rebase at this moment, could do it only on Monday.
If possible please apply only:

  s5p-fimc: Prevent lock up caused by incomplete H/W initialization
  v4l: Add VIDIOC_LOG_STATUS support for sub-device nodes

for 3.3 and drop the bottom four.

--
Thank you,
Sylwester

> Thanks!
> Mauro
