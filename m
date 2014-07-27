Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3623 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaG0JBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 05:01:05 -0400
Message-ID: <53D4BFC6.5020403@xs4all.nl>
Date: Sun, 27 Jul 2014 11:00:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Isaac Nickaein <nickaein.i@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: "error: redefinition of 'altera_init'" during build on Kernel
 3.0.36+
References: <CA+NJmkcTpf5Xb4Z8gJFriB58Jtf85ay_jnTS-fM34gA1PBf60g@mail.gmail.com> <53D4B013.2060404@xs4all.nl> <CA+NJmkcFLn5kVZe=4yUBcjAGp38-qAz_rx8eVapVnriANqZDNg@mail.gmail.com> <53D4B7B8.1040901@xs4all.nl> <CA+NJmkcnKxHWcPv-H9r=SQzOJD-DtnRc9voWz9a=BnsrgBv8kQ@mail.gmail.com>
In-Reply-To: <CA+NJmkcnKxHWcPv-H9r=SQzOJD-DtnRc9voWz9a=BnsrgBv8kQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2014 10:42 AM, Isaac Nickaein wrote:
> On Sun, Jul 27, 2014 at 12:56 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> No. Whoever maintains that repository applied v4l code from some newer
>> kernel without apparently ever testing it. This is really the responsibility
>> of maintainer of that repository and is out of our control.
>>
>> You need to address your questions to that repository maintainer, we can't
>> help, I'm afraid.
>>
> 
> Ah I see. I have some issues with v4l2 on this kernel version and I am
> trying to upgrade v4l2 to fix that.
> 
> One last question: Can I remove current v4l codes in kernel, replace
> them with the V4L2 backport (provided by linuxtv), fix the
> compatibility issues (hopefully) to get a kernel source with newer
> v4l2 code?
> 
> I am not sure if the v4l2 backport is the same type of code that is
> present in kernel source at "drivers/media/video",
> "drivers/media/dvb", etc.

Yes, you can, but it isn't easy.

In this repo:

http://git.linuxtv.org/cgit.cgi/hverkuil/cisco_build.git/tree/?h=cobalt-mainline

there is a patch-kernel.sh script that can patch a vendor kernel with the v4l
code from a fairly recent stable kernel (I think it is good for 3.14, I don't
know if it can backport from a 3.15 kernel).

You need to set the target, orig_source and source paths correctly and then
run it.

You end up with a huge patch that you can apply to your kernel.

It's probably still not enough since you may have to add compat code from
v4l/compat.h to the drivers you want to compile in. It depends on what
drivers you want to compile how much work that is.

I'm not going to give support for this, so you're on your own. The repo
owner really should fix his tree.

Regards,

	Hans
