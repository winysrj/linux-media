Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39333 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaGVAQ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 20:16:29 -0400
Message-ID: <53CDAD59.5050709@iki.fi>
Date: Tue, 22 Jul 2014 03:16:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] SDR stuff
References: <53C874F8.3020300@iki.fi> <20140721205005.28e2e784.m.chehab@samsung.com> <20140721210510.5980d794.m.chehab@samsung.com>
In-Reply-To: <20140721210510.5980d794.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2014 03:05 AM, Mauro Carvalho Chehab wrote:

>> total: 1 errors, 45 warnings, 1517 lines checked
>>
>> drivers/media/usb/msi2500/msi2500.c has style problems, please review.
>
> FYI, I applied the rest of this patch series, except for those patches:
> 	msi2500: move msi3101 out of staging and rename
> 	MAINTAINERS: update MSI3101 / MSI2500 driver location
> 	msi2500: change supported formats
> 	msi2500: print notice to point SDR API is not 100% stable yet
>
> Because the latter ones depend on the first patch.

Hey, just apply these too. As I explained, those are coming from new 
checkpatch checks added recently, after I have made that MSi3101/MSi2500 
driver. We should not start begin run new checkpatch tests for old 
drivers. One reason I really want these out from staging is checkpatch 
terrorism newbies are doing in staging. There is all kind of people 
doing some eucalyptys challenge, running very latest checkpatch and 
sending useless patches for these driver, just wasting only my time.

regards
Antti

-- 
http://palosaari.fi/
