Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55922 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZHQOw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 10:52:27 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Date: Mon, 17 Aug 2009 09:52:20 -0500
Subject: RE: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
 capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40145300B49@dlee06.ent.ti.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
 <200908151409.44219.hverkuil@xs4all.nl>
In-Reply-To: <200908151409.44219.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

They are applied against davinci tree (also mentioned in the patch). General procedure what I follow is to create platform code against davinci tree and v4l patches against v4l-dvb linux-next tree. The architecture part of linux-next is not up to date.

Davinci tree is at

git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Saturday, August 15, 2009 8:10 AM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; davinci-linux-open-
>source@linux.davincidsp.com; khilman@deeprootsystems.com
>Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
>capture driver
>
>On Friday 14 August 2009 23:01:41 m-karicheri2@ti.com wrote:
>> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>>
>> This patch makes the following changes:-
>> 	1) Modify vpif_subdev_info to add board_info, routing information
>> 	   and vpif interface configuration. Remove addr since it is
>> 	   part of board_info
>>
>> 	2) Add code to setup channel mode and input decoder path for
>> 	   vpif capture driver
>>
>> Also incorporated comments against version v0 of the patch series and
>> added a spinlock to protect writes to common registers
>
>A quick question: against which git tree are these arch changes applied?
>I've lost track of that :-)
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

