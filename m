Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55395 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab2EQVDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 17:03:16 -0400
Received: by wibhn6 with SMTP id hn6so2244494wib.1
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 14:03:15 -0700 (PDT)
Message-ID: <4FB5678F.2010000@gmail.com>
Date: Thu, 17 May 2012 23:03:11 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rtl2832 ver. 0.4: removed signal statistics
References: <1> <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-2-git-send-email-thomas.mair86@googlemail.com> <4FB50909.7030101@iki.fi> <4FB55F2D.8060000@gmail.com> <4FB56262.5020803@iki.fi> <4FB56371.1070605@googlemail.com> <4FB5646B.1090502@iki.fi>
In-Reply-To: <4FB5646B.1090502@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/17/2012 10:49 PM, Antti Palosaari wrote:
> On 17.05.2012 23:45, Thomas Mair wrote:
>> On 17.05.2012 22:41, Antti Palosaari wrote:
>>> On 17.05.2012 23:27, poma wrote:
>>>> On 05/17/2012 04:19 PM, Antti Palosaari wrote:
>>>>> Moikka Thomas,
>>>>>
>>>>> Here is the review. See comments below.
>>>>>
>>>>> And conclusion is that it is ready for the Kernel merge. I did not see
>>>>> any big functiuonality problems - only some small issues that are
>>>>> likely
>>>>> considered as a coding style etc. Feel free to fix those and sent new
>>>>> patc serie or just new patch top of that.
>>>>>
>>>>> Reviewed-by: Antti Palosaari<crope@iki.fi>
>>>
>>> [...]
>>>
>>>> rtl2832.c.diff:
>>>> - static int ->   static const
>>>> - struct ->   static const struct
>>>> - newline between function call and error check ->   […]
>>>> - 5 indications apropos 'spaces' regarding 'CodingStyle'- line 206
>>>> (/usr/share/doc/kernel-doc-3.3.5/Documentation/CodingStyle)
>>>> […]
>>>> Use one space around (on each side of) most binary and ternary
>>>> operators,
>>>> such as any of these:
>>>>
>>>>           =  +  -<    >    *  /  %  |&    ^<=>=  ==  !=  ?  :
>>>>
>>>> […]
>>>>
>>>> grep '>>\|<<'
>>>> v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig
>>>> +    len = (msb>>   3) + 1;
>>>> +        reading_tmp |= reading[i]<<   ((len-1-i)*8);
>>>> +    *val = (reading_tmp>>   lsb)&   mask;
>>>> +    len = (msb>>   3) + 1;
>>>> +        reading_tmp |= reading[i]<<   ((len-1-i)*8);
>>>> +    writing_tmp = reading_tmp&   ~(mask<<   lsb);
>>>> +    writing_tmp |= ((val&   mask)<<   lsb);
>>>> +        writing[i] = (writing_tmp>>   ((len-1-i)*8))&   0xff;
>>>> +    num = bw_mode<<   20;
>>>>
>>>> Bitshift operators seems to be OK.
>>>> Something else?
>>>
>>> (len-1-i)*8
>> I almost have a new corrected version of the patch series ready,
>> fixing this issues and the
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
>> For me checkpath.pl also does not report the error you reported. It
>> does seem
>> strange to me, as the makros are the same as in rtl2830_priv.h
> 
> Are you using some old version of checkpatch.pl ?
> Mine is:
> commit c06a9ebdb7a4f4823d4225fe789d8c20a1d534eb
> Author: Joe Perches <joe@perches.com>
> Date:   Mon Apr 16 13:35:11 2012 -0600
> 
> If you are using older version then upgrade. checkpatch.pl is developed
> very rapidly and there is all the time new checks.
> 
> regards
> Antti

https://github.com/torvalds/linux/blob/master/scripts/checkpatch.pl

./checkpatch.pl --version
Usage: checkpatch.pl [OPTION]... [FILE]...
Version: 0.32

Options:
  -q, --quiet                quiet
  --no-tree                  run without a kernel tree
  --no-signoff               do not check for 'Signed-off-by' line
  --patch                    treat FILE as patchfile (default)
  --emacs                    emacs compile window format
  --terse                    one line per report
  -f, --file                 treat FILE as regular source file
  --subjective, --strict     enable more subjective tests
  --ignore TYPE(,TYPE2...)   ignore various comma separated message types
  --show-types               show the message "types" in the output
  --root=PATH                PATH to the kernel tree root
  --no-summary               suppress the per-file summary
  --mailback                 only produce a report in case of
warnings/errors
  --summary-file             include the filename in summary
  --debug KEY=[0|1]          turn on/off debugging of KEY, where KEY is
one of
                             'values', 'possible', 'type', and 'attr'
(default
                             is all off)
  --test-only=WORD           report only warnings/errors containing WORD
                             literally
  -h, --help, --version      display this help and exit

When FILE is - read standard input.

./checkpatch.pl --no-tree
v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig
ERROR: Macros with complex values should be enclosed in parenthesis
#977: FILE: drivers/media/dvb/frontends/rtl2832_priv.h:30:
+#define dbg(f, arg...) \
+	if (rtl2832_debug) \
+		printk(KERN_INFO LOG_PREFIX": " f "\n" , ## arg)

ERROR: Missing Signed-off-by: line(s)

total: 2 errors, 0 warnings, 1177 lines checked

v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig has style
problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Bingo!

./checkpatch.pl --no-tree --file
v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig
ERROR: trailing whitespace
#8: FILE: v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig:8:
+ $

ERROR: trailing whitespace
#18: FILE: v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig:18:
+ $

ERROR: trailing whitespace
#30: FILE: v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig:30:
+ $

total: 3 errors, 0 warnings, 1205 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig has style
problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

regards,
poma
