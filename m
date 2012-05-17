Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab2EQUlJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 16:41:09 -0400
Message-ID: <4FB56262.5020803@iki.fi>
Date: Thu, 17 May 2012 23:41:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: Thomas Mair <thomas.mair86@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rtl2832 ver. 0.4: removed signal statistics
References: <1> <1337206420-23810-1-git-send-email-thomas.mair86@googlemail.com> <1337206420-23810-2-git-send-email-thomas.mair86@googlemail.com> <4FB50909.7030101@iki.fi> <4FB55F2D.8060000@gmail.com>
In-Reply-To: <4FB55F2D.8060000@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.05.2012 23:27, poma wrote:
> On 05/17/2012 04:19 PM, Antti Palosaari wrote:
>> Moikka Thomas,
>>
>> Here is the review. See comments below.
>>
>> And conclusion is that it is ready for the Kernel merge. I did not see
>> any big functiuonality problems - only some small issues that are likely
>> considered as a coding style etc. Feel free to fix those and sent new
>> patc serie or just new patch top of that.
>>
>> Reviewed-by: Antti Palosaari<crope@iki.fi>

[...]

> rtl2832.c.diff:
> - static int ->  static const
> - struct ->  static const struct
> - newline between function call and error check ->  […]
> - 5 indications apropos 'spaces' regarding 'CodingStyle'- line 206
> (/usr/share/doc/kernel-doc-3.3.5/Documentation/CodingStyle)
> […]
> Use one space around (on each side of) most binary and ternary operators,
> such as any of these:
>
>          =  +  -<   >   *  /  %  |&   ^<=>=  ==  !=  ?  :
>
> […]
>
> grep '>>\|<<' v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig
> +	len = (msb>>  3) + 1;
> +		reading_tmp |= reading[i]<<  ((len-1-i)*8);
> +	*val = (reading_tmp>>  lsb)&  mask;
> +	len = (msb>>  3) + 1;
> +		reading_tmp |= reading[i]<<  ((len-1-i)*8);
> +	writing_tmp = reading_tmp&  ~(mask<<  lsb);
> +	writing_tmp |= ((val&  mask)<<  lsb);
> +		writing[i] = (writing_tmp>>  ((len-1-i)*8))&  0xff;
> +	num = bw_mode<<  20;
>
> Bitshift operators seems to be OK.
> Something else?

(len-1-i)*8

> - 1 indication apropos 'media/dvb/frontends/rtl2832_priv.h:30'
> Compared to 'rtl2830_priv.h' seems to be OK.
>
> ./checkpatch.pl --no-tree
> v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig
> ERROR: Missing Signed-off-by: line(s)
>
> total: 1 errors, 0 warnings, 1177 lines checked
>
> v4-1-5-rtl2832-ver.-0.4-removed-signal-statistics.patch.orig has style
> problems, please review.  If any of these errors
> are false positives report them to the maintainer, see
> CHECKPATCH in MAINTAINERS.
>
> How do you produce this error:
> "ERROR: Macros with complex values should be enclosed in parenthesis…"?

Just running checkpatch.pl --file foo

And it is ERROR which means it *must* be corrected.

regards
Antti
-- 
http://palosaari.fi/
