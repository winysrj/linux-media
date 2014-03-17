Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1451 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbaCQNVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 09:21:44 -0400
Message-ID: <5326F6D3.8010307@xs4all.nl>
Date: Mon, 17 Mar 2014 14:21:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Ismael Luceno <ismael.luceno@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca_gl860: Clean up idxdata structs
References: <1394826203-26622-1-git-send-email-ismael.luceno@gmail.com> <53242699.3080308@redhat.com>
In-Reply-To: <53242699.3080308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2014 11:08 AM, Hans de Goede wrote:
> Hi,
> 
> Some better commit msg would be nice, otherwise this patch is:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> 
> Hans Verkuil has mailed me that he would like to pick this up through
> his tree. Hans V. , I say go for it :)

I noticed that these sparse warnings suddenly disappeared after switching to
sparse-0.5.0. It turns out to be a sparse bug:

commit 0edb7edecdd571c2663eb12acac1b27b9acac657
Author: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
Date:   Thu May 16 20:41:24 2013 +0100

    char.c: Fix parsing of escapes
    
    When parsing a string or character constant, the parse_escape()
    function returns a pointer to the character at which to resume
    parsing. However, in the case of an hex or octal escape, it was
    returning a one-past-the-end pointer. Thus, a string like:
    
        char str[3] = "\x61\x62\x63";
    
    was being parsed as:
    
        '\x61', 'x', '6', '2', '\x63'
    
    which, in turn, provokes an 'too long initializer' warning.
    
    Also, fix an off-by-one error in get_char_constant() when setting
    the 'end' pointer for a TOKEN_CHAR or TOKEN_WIDE_CHAR. Despite the
    name, the string->length of the token is actually the size of the
    allocated memory (ie len+1), so we need to compensate by using
    'token->string->length - 1'.

That said, I think it is really ugly to use a string like that and I still
would like to apply this patch, although for 3.16, not 3.15 as was my
original intention.

Hans, do you agree with that approach? Or do you prefer to keep it as is?

Regards,

	Hans

> 
> Regards,
> 
> Hans
> 
> 
> On 03/14/2014 08:43 PM, Ismael Luceno wrote:
>> Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
>> ---
>>   drivers/media/usb/gspca/gl860/gl860-mi2020.c | 464 ++++++++++++++++-----------
>>   1 file changed, 268 insertions(+), 196 deletions(-)
>>
>> diff --git a/drivers/media/usb/gspca/gl860/gl860-mi2020.c b/drivers/media/usb/gspca/gl860/gl860-mi2020.c
>> index 2edda6b..a785828 100644
>> --- a/drivers/media/usb/gspca/gl860/gl860-mi2020.c
>> +++ b/drivers/media/usb/gspca/gl860/gl860-mi2020.c
>> @@ -35,32 +35,34 @@ static u8 dat_hvflip5[] = {0x8c, 0xa1, 0x03};
>>   static u8 dat_hvflip6[] = {0x90, 0x00, 0x06};
>>
>>   static struct idxdata tbl_middle_hvflip_low[] = {
>> -	{0x33, "\x90\x00\x06"},
>> -	{6, "\xff\xff\xff"},
>> -	{0x33, "\x90\x00\x06"},
>> -	{6, "\xff\xff\xff"},
>> -	{0x33, "\x90\x00\x06"},
>> -	{6, "\xff\xff\xff"},
>> -	{0x33, "\x90\x00\x06"},
>> -	{6, "\xff\xff\xff"},
>> +	{0x33, {0x90, 0x00, 0x06}},
>> +	{6, {0xff, 0xff, 0xff}},
>> +	{0x33, {0x90, 0x00, 0x06}},
>> +	{6, {0xff, 0xff, 0xff}},
>> +	{0x33, {0x90, 0x00, 0x06}},
>> +	{6, {0xff, 0xff, 0xff}},
>> +	{0x33, {0x90, 0x00, 0x06}},
>> +	{6, {0xff, 0xff, 0xff}},
>>   };

<snip>

