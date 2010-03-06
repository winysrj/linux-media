Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:33539 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751557Ab0CFBHs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 20:07:48 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Fri, 5 Mar 2010 17:07:42 -0800
Message-ID: <4B91AADD.4030300@xenotime.net>
Date: Fri, 05 Mar 2010 17:07:41 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: VDR User <user.vdr@gmail.com>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: "Invalid module format"
References: <alpine.LNX.2.00.1003041737290.18039@banach.math.auburn.edu>	 <alpine.LNX.2.00.1003051829210.21417@banach.math.auburn.edu> <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com>
In-Reply-To: <a3ef07921003051651j12fbae25r5a3d5276b7da43b7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/05/10 16:51, VDR User wrote:
> On Fri, Mar 5, 2010 at 4:39 PM, Theodore Kilgore
> <kilgota@banach.math.auburn.edu> wrote:
>> This is to report the good news that none of the above suspicions have
>> panned out. I still do not know the exact cause of the problem, but a local
>> compile and install of the 2.6.33 kernel did solve the problem. Hence, it
>> does seem that the most likely origin of the problem is somewhere in the
>> Slackware-current tree and the solution does not otherwise concern anyone on
>> this list and does not need to be pursued here.
> 
> I experienced the same problem and posted a new thread about it with
> the subject "Problem with v4l tree and kernel 2.6.33".  I'm a debian
> user as well so apparently whatever is causing this is not specific to
> debian or slackware.  Even though you've got it working now, the
> source of the problem should be investigated.
> --

It's been several years since I last saw this error and I don't recall
what caused it then.

The message "Invalid module format" comes from either of modprobe and/or
insmod when the kernel returns ENOEXEC to a module (load) syscall.
Sometimes the kernel produces more explanatory messages  & sometimes not.

If there are no more explanatory messages, then kernel/module.c can be
built with DEBUGP producing more output (and then that new kernel would
have to be loaded).

Can one of you provide a kernel config file for a kernel/modprobe combination
that produces this message?  Some of the CONFIG_MODULE* config symbols could
have relevance here also.

-- 
~Randy
