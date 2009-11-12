Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45511 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbZKLPem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 10:34:42 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Thu, 12 Nov 2009 09:34:46 -0600
Subject: RE: [PATCH] V4L: adding digital video timings APIs
Message-ID: <A69FA2915331DC488A831521EAE36FE40155936BBF@dlee06.ent.ti.com>
References: <1256164939-21803-1-git-send-email-m-karicheri2@ti.com>
 <200911051356.29540.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40155936998@dlee06.ent.ti.com>
 <200911120718.26622.hverkuil@xs4all.nl>
In-Reply-To: <200911120718.26622.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
>Actually, the bridge driver only needs to override if it has multiple
>inputs
>where the capability flags differ (i.e. some inputs only support S_STD and
>others only support S_DV_PRESET).
>
>In all other cases the core will fill it in correctly.
>
>Doing it in the core ensures that the capability flags will be filled in so
>drivers don't need to remember doing this. The alternative is that you have
>to
>go through ALL existing drivers and add the new SUPPORTS_STD capability
>flag.
>

That is a good point to have it in the core. I will update the patch
and send it.

>But even then I am pretty certain that people will forget to set this flag
>for new upcoming drivers.
>
>So I prefer to have this set in the core and only drivers that have mixed
>inputs/outputs need to do a bit more work.
>
>Regards,
>
>	Hans
>
>>
>> Murali
>>
>> >Regards,
>> >
>> >	Hans
>> >
>> >--
>> >Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>>
>>
>>
>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

