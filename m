Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43982 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbbFHOdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 10:33:15 -0400
Message-ID: <5575A7A4.3010603@xs4all.nl>
Date: Mon, 08 Jun 2015 16:33:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Fabien DESSENNE <fabien.dessenne@st.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] bdisp: update MAINTAINERS
References: <5575896C.3090303@xs4all.nl> <15ED7CB7B68B4D4C96C7D27A1A23941201B9EFE120@SAFEX1MAIL2.st.com>
In-Reply-To: <15ED7CB7B68B4D4C96C7D27A1A23941201B9EFE120@SAFEX1MAIL2.st.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2015 03:36 PM, Fabien DESSENNE wrote:
> OK, I will take care of this new driver.

Sorry, but I need your Acked-by before I can merge this.

Regards,

	Hans

> 
>> -----Original Message-----
>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>> Sent: lundi 8 juin 2015 14:24
>> To: Linux Media Mailing List; Fabien DESSENNE
>> Subject: [PATCH] bdisp: update MAINTAINERS
>>
>> Add entry for the bdisp driver to the MAINTAINERS file.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3cfb979..de3cf29 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1964,6 +1964,14 @@ W:	http://bcache.evilpiepirate.org
>>  S:	Maintained:
>>  F:	drivers/md/bcache/
>>
>> +BDISP ST MEDIA DRIVER
>> +M:	Fabien Dessenne <fabien.dessenne@st.com>
>> +L:	linux-media@vger.kernel.org
>> +T:	git git://linuxtv.org/media_tree.git
>> +W:	http://linuxtv.org
>> +S:	Supported
>> +F:	drivers/media/platform/sti/bdisp
>> +
>>  BEFS FILE SYSTEM
>>  S:	Orphan
>>  F:	Documentation/filesystems/befs.txt

