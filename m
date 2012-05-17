Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48886 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2EQVTh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 17:19:37 -0400
Received: by wibhn6 with SMTP id hn6so2255112wib.1
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 14:19:34 -0700 (PDT)
Message-ID: <4FB56B63.7080703@googlemail.com>
Date: Thu, 17 May 2012 23:19:31 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rtl2832 ver. 0.4: removed signal statistics
References: <1> <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-2-git-send-email-thomas.mair86@googlemail.com> <4FB50909.7030101@iki.fi> <4FB55F2D.8060000@gmail.com> <4FB56262.5020803@iki.fi> <4FB56371.1070605@googlemail.com> <4FB568C9.70407@gmail.com>
In-Reply-To: <4FB568C9.70407@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.05.2012 23:08, poma wrote:
> On 05/17/2012 10:45 PM, Thomas Mair wrote:
>> On 17.05.2012 22:41, Antti Palosaari wrote:
>>> On 17.05.2012 23:27, poma wrote:
>>>> On 05/17/2012 04:19 PM, Antti Palosaari wrote:
>>>>> Moikka Thomas,
>>>>>
>>>>> Here is the review. See comments below.
>>>>>
>>>>> And conclusion is that it is ready for the Kernel merge. I did not see
>>>>> any big functiuonality problems - only some small issues that are likely
>>>>> considered as a coding style etc. Feel free to fix those and sent new
>>>>> patc serie or just new patch top of that.
>>>>>
>>>>> Reviewed-by: Antti Palosaari<crope@iki.fi>
>>>
>>> [...]
>>>
>>>> rtl2832.c.diff:
>>>> - static int ->  static const
>>>> - struct ->  static const struct
>>>> - newline between function call and error check ->  […]
>>>> - 5 indications apropos 'spaces' regarding 'CodingStyle'- line 206
>>>> (/usr/share/doc/kernel-doc-3.3.5/Documentation/CodingStyle)
>>>> […]
>>>> Use one space around (on each side of) most binary and ternary operators,
>>>> such as any of these:
>>>>
>>>>          =  +  -<   >   *  /  %  |&   ^<=>=  ==  !=  ?  :
>>>>
>>>> […]
>>>>
>>>> grep '>>\|<<' v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig
>>>> +    len = (msb>>  3) + 1;
>>>> +        reading_tmp |= reading[i]<<  ((len-1-i)*8);
>>>> +    *val = (reading_tmp>>  lsb)&  mask;
>>>> +    len = (msb>>  3) + 1;
>>>> +        reading_tmp |= reading[i]<<  ((len-1-i)*8);
>>>> +    writing_tmp = reading_tmp&  ~(mask<<  lsb);
>>>> +    writing_tmp |= ((val&  mask)<<  lsb);
>>>> +        writing[i] = (writing_tmp>>  ((len-1-i)*8))&  0xff;
>>>> +    num = bw_mode<<  20;
>>>>
>>>> Bitshift operators seems to be OK.
>>>> Something else?
>>>
>>> (len-1-i)*8
>> I almost have a new corrected version of the patch series ready, fixing this issues and the 
>> other ones you mentioned. 
>>>
>>>> - 1 indication apropos 'media/dvb/frontends/rtl2832_priv.h:30'
>>>> Compared to 'rtl2830_priv.h' seems to be OK.
>>>>
>>>> ./checkpatch.pl --no-tree
>>>> v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig
>>>> ERROR: Missing Signed-off-by: line(s)
>>>>
>>>> total: 1 errors, 0 warnings, 1177 lines checked
>>>>
>>>> v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig has style
>>>> problems, please review.  If any of these errors
>>>> are false positives report them to the maintainer, see
>>>> CHECKPATCH in MAINTAINERS.
>>>>
>>>> How do you produce this error:
>>>> "ERROR: Macros with complex values should be enclosed in parenthesis…"?
>>>
>>> Just running checkpatch.pl --file foo
>>>
>>
>> For me checkpath.pl also does not report the error you reported. It does seem
>> strange to me, as the makros are the same as in rtl2830_priv.h
>>
>> Regards 
>> Thomas
> 
> Yeah, 'rtl2830_priv.h' is the same.
> Fu… me, now I don't know too!
> :)
> 
> cheers,
> poma

Ok. I will then check the patches with the new checkpatch version tomorrow as I need some 
rest now ;) It should not be too difficult to remove the errors.

Regards 
Thomas
