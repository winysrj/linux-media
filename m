Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbZLDXFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 18:05:23 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Fri, 4 Dec 2009 17:05:28 -0600
Subject: RE: [PATCH v0 1/2] V4L - vpfe capture - convert ccdc drivers to
	platform drivers
Message-ID: <A69FA2915331DC488A831521EAE36FE40155BEBE21@dlee06.ent.ti.com>
References: <1259691333-32164-1-git-send-email-m-karicheri2@ti.com>
	<19F8576C6E063C45BE387C64729E7394043716AE11@dbde02.ent.ti.com>
 <A69FA2915331DC488A831521EAE36FE40155B775E9@dlee06.ent.ti.com>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE90CA4E@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE90CA4E@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sekhar,

>> >> +		status = -EBUSY;
>> >[Hiremath, Vaibhav] Is -EBUSY right return value, I think it should be -
>> >ENXIO or -ENOMEM.
>> >
>> I see -ENXIO & -ENOMEM being used by drivers. -ENXIO stands for "No such
>device or address". ENOMEM stands for "Out of memory" . Since we are trying
>to map the address here, -ENXIO looks reasonable to me. Same if
>request_mem_region() fails.
>>
>
>Sergei had posted on this earlier[1]. Quoting him here:

Was this his personal opinion or has he given any reference to support it?
I did a grep for this in the driver directory and the result I got is in inline with Sergie's suggestion. So I am going to update the patch with these and send it again.

-Murali
>
>"
>> What are the proper error codes when platform_get_resource,
>
>    -ENODEV.
>
>> request_mem_region
>
>    -EBUSY.
>
>> and ioremap functions fail?.
>
>    -ENOMEM.
>"
>
>Not sure if ioremap failure can relate to absence of a device.
>
>Thanks,
>Sekhar
>
>[1] http://www.mail-archive.com/davinci-linux-open-
>source@linux.davincidsp.com/msg14973.html

