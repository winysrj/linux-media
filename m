Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935288Ab1JFL5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Oct 2011 07:57:12 -0400
Message-ID: <4E8D9796.6090809@redhat.com>
Date: Thu, 06 Oct 2011 08:57:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH] media_build: two fixes + one unresolved issue
References: <201110051123.39783.hverkuil@xs4all.nl> <201110061043.24652.hverkuil@xs4all.nl> <4E8D87F6.10502@redhat.com> <201110061303.45629.hverkuil@xs4all.nl>
In-Reply-To: <201110061303.45629.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> The idea was good, but the patch didn't work ;)
>>
>> Fixed it. It is now properly recognizing the version 2.40 as 3.0.0 on both
>> scripts. See enclosed. I didn't apply it yet.
>
> Yeah, it's 2.6.40 to 3.0 instead of 2.40 to 3.0. It's amazing how quickly you
> forget :-)

Yes :)
>
>> Btw, I just applied another fix upstream. The most noticed effect is that
>> calling make -C linux apply_patches will now show:
>> 	Patches for 2.6.40.4-5.fc15.x86_64 already applied.
>> instead of:
>> 	Patches for  already applied.
>
> Nice!
>
>> -
>> Fix Name convention for kernels 2.6.40 and upper
>>
>> Based on a patch from Hans Verkuil<hverkuil@xs4all.nl>
>>
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>
>> diff --git a/linux/patches_for_kernel.pl b/linux/patches_for_kernel.pl
>> index 33348d9..2669e6c 100755
>> --- a/linux/patches_for_kernel.pl
>> +++ b/linux/patches_for_kernel.pl
>> @@ -13,11 +13,18 @@ my $file = "../backports/backports.txt";
>>    open IN, $file or die "can't find $file\n";
>>
>>    sub kernel_version($) {
>> -	my $sublevel;
>> +	my ($version, $patchlevel, $sublevel) = $_[0] =~
>> m/^(\d+)\.(\d+)\.?(\d*)/;
>>
>> -	$_[0] =~ m/^(\d+)\.(\d+)\.?(\d*)/;
>> -	$sublevel = $3 == "" ? 0 : $3;
>> -	return ($1*65536 + $2*256 + $sublevel);
>> +	# fix kernel version for distros that 'translated' 3.0 to 2.40
>
> This comment is wrong, it should be 2.6.40.
>
>> +	$version += 0;
>> +	$patchlevel += 0;
>
> These two lines seems to be leftovers from debugging.

Yes. Ok, fixed on a separate patch.

> I assume you will commit this?

I can do it.

Ok, done!

Thanks!
Mauro
