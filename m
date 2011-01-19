Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:63502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1ASLd0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 06:33:26 -0500
Message-ID: <4D36CBF2.5080002@redhat.com>
Date: Wed, 19 Jan 2011 09:33:06 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PATCHES FOR 2.6.38] Compile error fix
References: <201101182103.49349.hverkuil@xs4all.nl> <201101190241.40529@orion.escape-edv.de>
In-Reply-To: <201101190241.40529@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-01-2011 23:41, Oliver Endriss escreveu:
> On Tuesday 18 January 2011 21:03:49 Hans Verkuil wrote:
>> Hi Mauro,
>>
>> That beautiful 'OK' from the daily build disappeared again. This should bring
>> it back :-)
>>
>> Regards,
>>
>> 	Hans
>>
>> The following changes since commit fd4564a8c4f23b5ea6526180898ca2aedda2444e:
>>   Jarod Wilson (1):
>>         [media] staging/lirc: fix mem leaks and ptr err usage
>>
>> are available in the git repository at:
>>
>>   ssh://linuxtv.org/git/hverkuil/media_tree.git cxd2099
> 
> I've already posted that fix here:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg27186.html
> https://patchwork.kernel.org/patch/485781/

Hi Oliver,

Thanks for the patch. I noticed that problem late night when preparing my linux-next tree,
and added the same fix you did there:
	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=9fca5943233de717b3edcd4a84a51d93e3eae302

Hans/Oliver,

I didn't backport it yet to the main tree. I'll be doing it today.

Cheers,
Mauro
