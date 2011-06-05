Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41989 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab1FESLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 14:11:48 -0400
Received: by eyx24 with SMTP id 24so1140574eyx.19
        for <linux-media@vger.kernel.org>; Sun, 05 Jun 2011 11:11:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DEBB18A.4020504@redhat.com>
References: <4DEB7E9E.6040102@redhat.com>
	<4DEB8B7E.6070507@redhat.com>
	<4DEB9D32.2070105@mailbox.hu>
	<4DEBB18A.4020504@redhat.com>
Date: Sun, 5 Jun 2011 14:11:46 -0400
Message-ID: <BANLkTikK4PsBkUkC_99F92H3A=ubxYo4Bw@mail.gmail.com>
Subject: Re: xc4000 patches folded
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Istvan Varga <istvan_v@mailbox.hu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, June 5, 2011, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Em 05-06-2011 12:13, Istvan Varga escreveu:
>> On 06/05/2011 03:58 PM, Mauro Carvalho Chehab wrote:
>>
>>> Don't add \n\t\t at the beginning of the param_desc. Even the extra \t and \n
>>> format stuff in the middle of the description is unusual. It is better to avoid,
>>> as it may break scripts.
>>
>> OK, I will remove the tabs. Is the use of \n allowed in the description?
>
> Never saw \n on a param description. The description is generally just a
> summary. The full parameters description should be at
> Documentation/kernel-parameters.txt (although, unfortunately, people
> generally forget to update the parameters there).
>
>>> Please put all parameters together.
>>
>> Does this mean that the macro definitions should be moved from between
>> the parameter definitions ?
>
> We generally put macro definitions after that. Some drivers just move all
> parameters to the end of the file.
>
>>> Don't add a card_type. Just add the features that are needed for
>>> XC4000_CARD_WINFAST_CX88 to work.
>>
>> Yes, this is a change I have already planned. The following parameters
>> will be added to the priv and config structures:
>>   - the default enabling of power management
>>   - amplitude for DVB-T
>> The other conditionals might not actually be necessary, they were just
>> added to avoid changing the behavior of the driver with the PCTV 340e
>> which I cannot test.
>
> Ok. Well, we can ask Devin or one of the PCTV owners to test.
>
>> A third parameter could be added to enable/disable
>> the use of XREG_SMOOTHEDCVBS, although it is not really needed with the
>> currently supported cards (always enabling it should not be a problem).
>
> Ok.
>
>>> Please use a generic parameter. In this case, it seems that it is just
>>> disabling one video mode. I don't think you need this here, as the better
>>> is to disable such video mode in cx88. Hard to tell without seeing the
>>> cx88 code that adds support for the Winfast xc4000-based card.
>>
>> I do not think making it card-specific is really needed. It is probably
>> best to just remove the card_type check here. Also, the code is there
>> only to improve support for old (1.2) firmware versions.
>
> Ok.
>
>> For xc4000.c and xc4000.h, is it enough to create the following three
>> patches, or should the changes be broken up into more smaller patches ?
>>   - removing the use of card_type
>>   - uncommenting the firmware version check
>>   - coding style / cleanup
>
> I think so.
>
> Ah, we need also to work at the firmware stuff. The better is to add the
> firmware files at the firmware tree, at kernel.org. If this is not possible,
> then we need to work on another way to provide it.

I'll be working with Istvan on this.  I secured the redistribution
rights with xceive so this shouldn't be an issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
