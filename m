Return-path: <mchehab@gaivota>
Received: from mail-pz0-f66.google.com ([209.85.210.66]:51243 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0LaR67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 12:58:59 -0500
Message-ID: <4D1E19F7.6000608@gmail.com>
Date: Fri, 31 Dec 2010 09:59:19 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
	Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org,
	devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-m68k@lists.linux-m68k.org,
	spi-devel-general@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <20101231064515.GC3733@angua.secretlab.ca> <4D1D7DAE.7060504@gmail.com> <20101231091136.GC1886@bicker> <4D1DE616.7010105@gmail.com> <20101231174100.GF1886@bicker>
In-Reply-To: <20101231174100.GF1886@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/31/2010 09:41 AM, Dan Carpenter wrote:
> On Fri, Dec 31, 2010 at 06:17:58AM -0800, Justin P. Mattock wrote:
>>> Wrong:  [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.
>>>
>>> Right:  [PATCH 02/15] spi/dw_spi: Typo change diable to disable
>>>
>>> regards,
>>> dan carpenter
>>>
>>
>> alright.. so having the backlash is alright for the subject
>
> Well really my point is not so much about backslashes vs colons, it's
> about getting the *one* correct prefix.  This stuff is probably
> scriptable most of the time, but you may still be required to think a
> little on the corner cases.
>
> Here is a script to get you started.
>
> git log --format="%s" drivers/spi/dw_spi.c | \
> 	head -n 20 |                         \
> 	perl -ne 's/(.*):.*/$1/; print' |    \
> 	sort | uniq -c | sort -rn |          \
> 	perl -ne 's/^\W+\d+ //; print' |     \
> 	head -n 1
>
> regards,
> dan carpenter
>

thats a nice little script there(just ran it) any way you want to add 
this into to getmaintainers.pl or something? (this way people get the 
maintainers address plus a subject line in the mix)

Justin P. Mattock
