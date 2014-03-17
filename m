Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaCQTVM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 15:21:12 -0400
Message-ID: <53274B1A.3080906@redhat.com>
Date: Mon, 17 Mar 2014 20:20:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Ismael Luceno <ismael.luceno@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca_gl860: Clean up idxdata structs
References: <1394826203-26622-1-git-send-email-ismael.luceno@gmail.com> <53242699.3080308@redhat.com> <5326F6D3.8010307@xs4all.nl>
In-Reply-To: <5326F6D3.8010307@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/17/2014 02:21 PM, Hans Verkuil wrote:
> On 03/15/2014 11:08 AM, Hans de Goede wrote:
>> Hi,
>>
>> Some better commit msg would be nice, otherwise this patch is:
>>
>> Acked-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Hans Verkuil has mailed me that he would like to pick this up through
>> his tree. Hans V. , I say go for it :)
> 
> I noticed that these sparse warnings suddenly disappeared after switching to
> sparse-0.5.0. It turns out to be a sparse bug:
> 
> commit 0edb7edecdd571c2663eb12acac1b27b9acac657
> Author: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
> Date:   Thu May 16 20:41:24 2013 +0100
> 
>     char.c: Fix parsing of escapes
>     
>     When parsing a string or character constant, the parse_escape()
>     function returns a pointer to the character at which to resume
>     parsing. However, in the case of an hex or octal escape, it was
>     returning a one-past-the-end pointer. Thus, a string like:
>     
>         char str[3] = "\x61\x62\x63";
>     
>     was being parsed as:
>     
>         '\x61', 'x', '6', '2', '\x63'
>     
>     which, in turn, provokes an 'too long initializer' warning.
>     
>     Also, fix an off-by-one error in get_char_constant() when setting
>     the 'end' pointer for a TOKEN_CHAR or TOKEN_WIDE_CHAR. Despite the
>     name, the string->length of the token is actually the size of the
>     allocated memory (ie len+1), so we need to compensate by using
>     'token->string->length - 1'.
> 
> That said, I think it is really ugly to use a string like that and I still
> would like to apply this patch, although for 3.16, not 3.15 as was my
> original intention.
> 
> Hans, do you agree with that approach? Or do you prefer to keep it as is?

I agree that using strings for this is ugly, and I would still like to see
this patch go in. I've no preference for putting it in 3.15 or 3.16 .

Regards,

Hans
