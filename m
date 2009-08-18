Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37284 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbZHRQHX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 12:07:23 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 18 Aug 2009 11:06:54 -0500
Subject: RE: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
 capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE401548C1E27@dlee06.ent.ti.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
 <A69FA2915331DC488A831521EAE36FE40145300FC7@dlee06.ent.ti.com>
 <200908180849.14003.hverkuil@xs4all.nl>
 <200908180851.06222.hverkuil@xs4all.nl>
In-Reply-To: <200908180851.06222.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I need to send a set of patches for adding vpif capture driver. Currently the linux-next doesn't have the last patch from Chaithrika applied for vpif display. Is it possible to apply this asap so that I can create the vpif capture patch today?

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Tuesday, August 18, 2009 2:51 AM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; davinci-linux-open-
>source@linux.davincidsp.com; khilman@deeprootsystems.com
>Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
>capture driver
>
>On Tuesday 18 August 2009 08:49:13 Hans Verkuil wrote:
>> On Tuesday 18 August 2009 01:23:10 Karicheri, Muralidharan wrote:
>> > Hans,
>> >
>> > I have re-send vpfe capture patch. I will re-send vpif patches tomorrow.
>>
>> These patches apply fine. I'll merge them in my v4l-dvb-dm646x tree
>tonight.
>
>Oops, wrong tree. It's v4l-dvb-vpif.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

