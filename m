Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:55146 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZKJFXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 00:23:54 -0500
Message-ID: <4AF8F8EB.8090705@freemail.hu>
Date: Tue, 10 Nov 2009 06:23:55 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-dbg: report fail reason to the user
References: <4AF6BA72.4070809@freemail.hu> <200911091116.06578.hverkuil@xs4all.nl>
In-Reply-To: <200911091116.06578.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 08 November 2009 13:32:50 Németh Márton wrote:
>> From: Márton Németh <nm127@freemail.hu>
>>
>> Report the fail reason to the user when writing a register even if
>> the verbose mode is switched off.
>>
>> Remove duplicated code ioctl() call which may cause different ioctl()
>> function call in case of verbose and non verbose if not handled carefully.
>>
>> Signed-off-by: Márton Németh <nm127@freemail.hu>
>> ---
>> diff -r 19c0469c02c3 v4l2-apps/util/v4l2-dbg.cpp
>> --- a/v4l2-apps/util/v4l2-dbg.cpp	Sat Nov 07 15:51:01 2009 -0200
>> +++ b/v4l2-apps/util/v4l2-dbg.cpp	Sun Nov 08 14:13:52 2009 +0100
>> @@ -354,13 +354,14 @@
>>  {
>>  	int retVal;
>>
>> -	if (!options[OptVerbose]) return ioctl(fd, request, parm);
>>  	retVal = ioctl(fd, request, parm);
>> -	printf("%s: ", name);
>> -	if (retVal < 0)
>> -		printf("failed: %s\n", strerror(errno));
>> -	else
>> -		printf("ok\n");
>> +	if (options[OptVerbose]) {
>> +		printf("%s: ", name);
>> +		if (retVal < 0)
>> +			printf("failed: %s\n", strerror(errno));
> 
> Strictly speaking if the printf two line back would produce an error, then
> errno would now contain the errno from the printf and not from the ioctl.
> So errno should be assigned to a local variable right after the ioctl.
> 
> Note that this was already a bug in the original code.

You are right, this problem was not solved by the new code.

> Note also that I fail to see any difference in the old vs the new code.

In this function I only tried to modify the programming style: only one call to
ioctl(). In the original code the ioctl() call was duplicated which which
results a not-so-well maintainable code: if ever is needed to modify the parameters
of the ioctl() then in the original code two lines would be needed to modify. The
lines are to be modified exactly the same way in that case which may result different
behaviour in case of verbose switched on or off.

> 
>> +		else
>> +			printf("ok\n");
>> +	}
>>
>>  	return retVal;
>>  }
>> @@ -586,8 +587,9 @@
>>
>>  				printf(" set to 0x%llx\n", set_reg.val);
>>  			} else {
>> -				printf("Failed to set register 0x%08llx value 0x%llx\n",
>> -					set_reg.reg, set_reg.val);
>> +				printf("Failed to set register 0x%08llx value 0x%llx: "
>> +					"%s\n",
> 
> Please keep this printf on one line. Yes, you get a checkpatch warning but
> I'd rather have a slightly longer line than an ugly split line.
> 
> Regards,
> 
> 	Hans
> 
>> +					set_reg.reg, set_reg.val, strerror(errno));
>>  			}
>>  			set_reg.reg++;
>>  		}

