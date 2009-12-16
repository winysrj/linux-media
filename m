Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34661 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076AbZLPQpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 11:45:54 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	"Nori, Sekhar" <nsekhar@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 16 Dec 2009 10:45:51 -0600
Subject: RE: [PATCH - v1 4/6] V4L - vpfe_capture bug fix and enhancements
Message-ID: <A69FA2915331DC488A831521EAE36FE401625D0DCF@dlee06.ent.ti.com>
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com>
 <200912152220.41459.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE401625D0BCC@dlee06.ent.ti.com>
 <200912160841.57444.hverkuil@xs4all.nl>
In-Reply-To: <200912160841.57444.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hans,

>>
>> Yes, isif_config_bclamp() set values in the register.
>
>Huh? That does not explain why apparently bc->horz.win_h_sz_calc can be
>larger
>than ISIF_HORZ_BC_WIN_H_SIZE_MASK.
because the values come from the user and since we can't use the enum
for the types, I have to make sure the value is within range. Other way
to do is to check the value in the validate() function. I am inclined to
do the validation so that the & statements with masks can be removed while setting it in the register.

>
>Regards,
>
>	Hans
>
>>
>> >
>> >It would be interesting to know if people know of good ways of making
>> >awkward
>> >code like this more elegant (or at least less awkward).
>> >
>> >Regards,
>> >
>> >	Hans
>> >
>> >--
>> >Hans Verkuil - video4linux developer - sponsored by TANDBERG
>>
>>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG
