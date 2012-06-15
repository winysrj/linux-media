Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53926 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755344Ab2FOQPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 12:15:44 -0400
Message-ID: <4FDB5F9D.3030406@xenotime.net>
Date: Fri, 15 Jun 2012 09:15:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Patches
References: <CA+MoWDpfKTsW1YDwVwWYqDHrT=yXih6YVUtttSHerku83MSUGg@mail.gmail.com>	<4FDA5B07.4040304@xenotime.net> <CA+MoWDq-exxGDbP4KjWJjU8RJKBb4vGO_Dk_C6UcGrzRmu-hiA@mail.gmail.com>
In-Reply-To: <CA+MoWDq-exxGDbP4KjWJjU8RJKBb4vGO_Dk_C6UcGrzRmu-hiA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2012 05:23 PM, Peter Senna Tschudin wrote:

> Hello Randy,
> 
>>> ./scripts/get_maintainer.pl  -f drivers/media/video/cx231xx/
>> Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT INFRA...,commit_signer:23/24=96%)
>> Devin Heitmueller <dheitmueller@kernellabs.com> (commit_signer:4/24=17%)
>> Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:4/24=17%)
>> Thomas Petazzoni <thomas.petazzoni@free-electrons.com> (commit_signer:4/24=17%)
>> linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
>> linux-kernel@vger.kernel.org (open list)
> 
> When I run it pointing to the patch, it also includes Julia Lawall and
> Greg Kroah-Hartman. See:
> 
> $ scripts/get_maintainer.pl
> outgoing/0001-RESEND-cx231xx-Paranoic-stack-memory-save.patch
> Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT
> INFRA...,commit_signer:11/12=92%)
> Thomas Petazzoni <thomas.petazzoni@free-electrons.com> (commit_signer:3/12=25%)
> Devin Heitmueller <dheitmueller@kernellabs.com> (commit_signer:2/12=17%)
> Julia Lawall <julia@diku.dk> (commit_signer:1/12=8%)
> Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:1/12=8%)
> linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
> linux-kernel@vger.kernel.org (open list)
> 
> The patch was sent to all people above but Greg did not get it due
> invalid E-mail. I've removed linux-kernel@vger.kernel.org list.
> 
>>
>>
>> That (above) should be enough.
>> If you feel that you need to copy GregKH on the patches, his current
>> email address is in the MAINTAINERS file.
> I feel there is no need of sending the patch to him, but I'm not sure
> about the need of reporting the broken E-mail.


Nope.  The script is reporting what is in the git log,
and that was Greg's email address when those patches were made.
Just because his email address changed, we are not going to modify
the patch logs with his current email address.

-- 
~Randy
