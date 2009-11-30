Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42807 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZK3SEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 13:04:24 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"diego.dompe@ridgerun.com" <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Mon, 30 Nov 2009 12:04:14 -0600
Subject: RE: [PATCH 3/4 v10] TVP7002 driver for DM365
Message-ID: <A69FA2915331DC488A831521EAE36FE40155AD7C61@dlee06.ent.ti.com>
References: <1259361140-14526-1-git-send-email-santiago.nunez@ridgerun.com>
 <200911280406.39013.hverkuil@xs4all.nl>
In-Reply-To: <200911280406.39013.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Friday, November 27, 2009 10:07 PM
>To: santiago.nunez@ridgerun.com
>Cc: davinci-linux-open-source@linux.davincidsp.com; linux-
>media@vger.kernel.org; Narnakaje, Snehaprabha; Karicheri, Muralidharan;
>diego.dompe@ridgerun.com; todd.fischer@ridgerun.com; Grosen, Mark
>Subject: Re: [PATCH 3/4 v10] TVP7002 driver for DM365
>
>On Friday 27 November 2009 23:32:20 santiago.nunez@ridgerun.com wrote:
>> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
>>
>> This patch provides the implementation of the TVP7002 decoder
>> driver for DM365. Implemented using the V4L2 DV presets API.
>> Removed shadow register values. Testing shows that the device
>> needs not to be powered down and up for correct behaviour.
>> Improved readability.
>>
Ok. That is great!. Looks like we are almost ready for merge.
So please ignore my previous comments to keep this issue as a TODO
list.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com
