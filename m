Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64767 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaEIEgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 00:36:24 -0400
Message-ID: <536C5B42.2060208@gmail.com>
Date: Fri, 09 May 2014 10:06:18 +0530
From: Arun Kumar K <arunkk.samsung@gmail.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Arun Kumar K' <arun.kk@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>, posciak@chromium.org,
	avnd.kiran@samsung.com
Subject: Re: [PATCH v2] [media] s5p-mfc: add init buffer cmd to MFCV6
References: <1394529345-31952-1-git-send-email-arun.kk@samsung.com> <004c01cf6ad9$bcc0e780$3642b680$%debski@samsung.com>
In-Reply-To: <004c01cf6ad9$bcc0e780$3642b680$%debski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On 05/08/14 21:52, Kamil Debski wrote:
> Hi,
> 
>> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com] On Behalf Of Arun
>> Kumar K
>> Sent: Tuesday, March 11, 2014 10:16 AM
>>
>> From: avnd kiran <avnd.kiran@samsung.com>
>>
>> Latest MFC v6 firmware requires tile mode and loop filter setting to be
>> done as part of Init buffer command, in sync with v7. Since there are
>> two versions of v6 firmware with different interfaces, it is
>> differenciated using the version number read back from firmware which
>> is a hexadecimal value based on the firmware date.
> 
> MFC version has two parts major and minor. Are you sure that date is 
> the only way to check if the interface has changed? Maybe the major number
> should stay the same (6) in this case, and the minor should be updates?
> Do you have contact with persons writing the firmware?
> 

Yes I contacted with the firmware team and there is no difference in the
minor number too. Both the versions will read as MFC v6.5. Only
difference is the firmware date.

> Also, I don't see a patch with the newer firmware posted to linux-firmware.
> When it is going to be sent?
> 

I will send it along with the v7 firmware.

Regards
Arun

> Best wishes,
> 
