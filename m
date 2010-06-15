Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36283 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0FOD4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 23:56:31 -0400
Message-ID: <4C16F9FC.2080905@gmail.com>
Date: Mon, 14 Jun 2010 20:56:44 -0700
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
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost>            <4C16E18F.9050901@gmail.com> <9275.1276573789@localhost>
In-Reply-To: <9275.1276573789@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2010 08:49 PM, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 14 Jun 2010 19:12:31 PDT, "Justin P. Mattock" said:
>
>> what I tried was this:
>>
>> if (!rc)
>> 	printk("test........"\n")
>>
>> and everything looked good,
>> but as a soon as I changed
>>
>> rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE,
>>      			"attempting to determine the timeouts");
>>
>> to this:
>>
>> rc = transmit_cmd(chip,&tpm_cmd, TPM_INTERNAL_RESULT_SIZE);
>>
>> if (!rc)
>> 	printk("attempting to determine the timeouts\n");
>
> *baffled* Why did you think that would work? transmit_cmd()s signature
> has 4 parameters.

I have no manual in front of me. Did a quick google, but came up with 
(no hits) info on what that function does. grep showed too many entries 
to really see why/what this is. So I kind of just scrambled with this one.

Justin P. Mattock
