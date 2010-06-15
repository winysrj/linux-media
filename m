Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:46603 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab0FOCMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 22:12:17 -0400
Message-ID: <4C16E18F.9050901@gmail.com>
Date: Mon, 14 Jun 2010 19:12:31 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
	debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
	linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but not
 used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>            <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost>
In-Reply-To: <21331.1276560832@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2010 05:13 PM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 14 Jun 2010 13:26:44 PDT, "Justin P. Mattock" said:
>> Im getting this warning when compiling:
>>   CC      drivers/char/tpm/tpm.o
>> drivers/char/tpm/tpm.c: In function 'tpm_gen_interrupt':
>> drivers/char/tpm/tpm.c:508:10: warning: variable 'rc' set but not used
>>
>> The below patch gets rid of the warning,
>> but I'm not sure if it's the best solution.
>
>>   	rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>>   			"attempting to determine the timeouts");
>> +	if (!rc)
>> +		rc = 0;
>>   }
>
> Good thing that's a void function. ;)
>
> Unless transmit_cmd() is marked 'must_check', maybe losing the 'rc =' would
> be a better solution?


what I tried was this:

if (!rc)
	printk("test........"\n")

and everything looked good,
but as a soon as I changed

rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
    			"attempting to determine the timeouts");

to this:

rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE);

if (!rc)
	printk("attempting to determine the timeouts\n");

I error out with transmit_cmd not having enough
functions to it.. so I just added the rc = 0;
and went on to the next.

Justin P. Mattock
