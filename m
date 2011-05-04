Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:56584 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1EDLbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 07:31:15 -0400
Message-ID: <4DC138F7.5050400@infradead.org>
Date: Wed, 04 May 2011 08:31:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
CC: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx18: Clean up mmap() support for raw YUV
References: <4DBFDF71.5090705@redhat.com> <1304423860-12785-1-git-send-email-simon.farnsworth@onelan.co.uk> <b418b252-4152-4666-9c83-85e91613b493@email.android.com> <201105041032.24644.simon.farnsworth@onelan.co.uk>
In-Reply-To: <201105041032.24644.simon.farnsworth@onelan.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-05-2011 06:32, Simon Farnsworth escreveu:
> On Tuesday 3 May 2011, Andy Walls <awalls@md.metrocast.net> wrote:
>> Simon,
>>
>> If these two changes are going in, please also bump the driver version to
>> 1.5.0 in cx18-version.c.  These changes are significant enough
>> perturbation.
>>
>> End users are going to look to driver version 1.4.1 as the first version
>> for proper analog tuner support of the HVR1600 model 74351.
>>
>> Mauro,
>>
>> Is cx18 v1.4.1 with HVR1600 model 74351 analog tuner support, without these
>> mmap() changes going to be visible in kernel version .39 ?
>>
> 
> Mauro,
> 
> If you're going to accept these two patches, would you mind bumping the 
> version in cx18-version.c for me as you apply them, or would you prefer me to 
> provide either an incremental patch or a new patch with the bump added?

Please, provide me a patch for it. I'm still stuck handling pending patches,
as patchwork lost some stuff.

Thanks!
Mauro
