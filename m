Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2HPKai (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 06:30:38 -0400
Message-ID: <502CCBC8.4060504@redhat.com>
Date: Thu, 16 Aug 2012 07:30:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] tree renaming patches part 1 applied
References: <502A3DAF.6080301@redhat.com> <502CBC37.1010800@samsung.com>
In-Reply-To: <502CBC37.1010800@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-08-2012 06:24, Sylwester Nawrocki escreveu:
> Hi Mauro,
> 
> On 08/14/2012 01:59 PM, Mauro Carvalho Chehab wrote:
>> Anyway, in order to help people that might still have patches against
>> the old structure, I created a small script and added them at the
>> media_build tree:
>> 	http://git.linuxtv.org/media_build.git/blob/HEAD:/devel_scripts/rename_patch.sh
>>
>> (in fact, I created an script that auto-generated it ;) )
>>
>> To use it, all you need to do is:
>>
>> 	$ ./rename_patch.sh your_patch
>>
>> As usual, if you want to change several patches, you could do:
>> 	$ git format_patch some_reference_cs
>>
>> and apply the rename_patch.sh to the generated 0*.patch files, like
>> 	$ for i in 0*.patch; do ./rename_patch.sh $i; done
>>
>> More details about that are at the readme file:
>> 	http://git.linuxtv.org/media_build.git/blob/HEAD:/devel_scripts/README
> 
> Thanks for preparing this little helper script! It's helpful since I have
> quite a few pending patches, and it also saves time when porting patches
> from older kernel trees.

Anytime!

Anyway, I'm running this script here, when a patch doesn't apply, so, you
don't urge to port patches to the new structure.

Regards,
Mauro
