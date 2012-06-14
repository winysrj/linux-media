Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51349 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751288Ab2FNVnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 17:43:51 -0400
Message-ID: <4FDA5B07.4040304@xenotime.net>
Date: Thu, 14 Jun 2012 14:43:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Patches
References: <CA+MoWDpfKTsW1YDwVwWYqDHrT=yXih6YVUtttSHerku83MSUGg@mail.gmail.com>
In-Reply-To: <CA+MoWDpfKTsW1YDwVwWYqDHrT=yXih6YVUtttSHerku83MSUGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2012 11:12 AM, Peter Senna Tschudin wrote:

> Dear Mauro,
> 
> I've just send some patches. Some are being sent again just to group
> my patches. The cx231xx patch was resent because I forgot to CC the
> maintainers of the patch. For the pvrusb2, I've grouped four commits
> into one.
> 
> get_maintainers.pl has reported that one of the maintainers of cx231xx
> is Greg Kroah-Hartman <gregkh@suse.de>, but this E-mail do not exist
> any more. Should I report this somewhere?



> ./scripts/get_maintainer.pl  -f drivers/media/video/cx231xx/
Mauro Carvalho Chehab <mchehab@infradead.org> (maintainer:MEDIA INPUT INFRA...,commit_signer:23/24=96%)
Devin Heitmueller <dheitmueller@kernellabs.com> (commit_signer:4/24=17%)
Hans Verkuil <hans.verkuil@cisco.com> (commit_signer:4/24=17%)
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> (commit_signer:4/24=17%)
linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...)
linux-kernel@vger.kernel.org (open list)


That (above) should be enough.
If you feel that you need to copy GregKH on the patches, his current
email address is in the MAINTAINERS file.


thanks,
-- 
~Randy
