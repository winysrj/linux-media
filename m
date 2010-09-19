Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:13142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab0ISFem (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 01:34:42 -0400
Message-ID: <4C959EB1.2050608@redhat.com>
Date: Sun, 19 Sep 2010 02:25:05 -0300
From: Douglas Schilling Landgraf <dougsland@redhat.com>
Reply-To: dougsland@redhat.com
MIME-Version: 1.0
To: David Ellingsworth <david@identd.dyndns.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH -hg] Warn user that driver is backported and might not
 work as expected
References: <4C938158.9020604@redhat.com> <AANLkTinEXUcQ-iTucDArju+daudTgAHoBTCBdproK7se@mail.gmail.com>
In-Reply-To: <AANLkTinEXUcQ-iTucDArju+daudTgAHoBTCBdproK7se@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

David Ellingsworth wrote:
> <snip>
>> --- a/v4l/scripts/make_kconfig.pl       Sun Jun 27 17:17:06 2010 -0300
>> +++ b/v4l/scripts/make_kconfig.pl       Fri Sep 17 11:49:02 2010 -0300
>> @@ -671,4 +671,13 @@
>>
>>  EOF2
>>        }
>> +print << "EOF3";
>> +WARNING: This is the V4L/DVB backport tree, with experimental drivers
>> +        backported to run on legacy kernels from the development tree at:
>> +               http://git.linuxtv.org/media-tree.git.
>> +        It is generally safe to use it for testing a new driver or
>> +        feature, but its usage on production environments is risky.
>> +        Don't use it at production. You've being warned.
> 
> The last line should read: "Don't use it in production. You've been warned."
> 

Fixed thanks!

Cheers
Douglas
