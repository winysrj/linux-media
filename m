Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2614 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaBSIyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 03:54:53 -0500
Message-ID: <5304714C.6020706@xs4all.nl>
Date: Wed, 19 Feb 2014 09:54:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	pete@sensoray.com, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [REVIEWv3 PATCH 00/35] Add support for complex controls, use
 in solo/go7007
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl> <CAPybu_26nHL-NPVgT8zxDoMh-EtE0yYLVjpu93deMQxW8PA2Ng@mail.gmail.com>
In-Reply-To: <CAPybu_26nHL-NPVgT8zxDoMh-EtE0yYLVjpu93deMQxW8PA2Ng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/14 09:28, Ricardo Ribalda Delgado wrote:
> Hello.
> 
> I did tried stressfully the previous patchset (REVIEWv2). I am
> specially interested in the matrix controls.
> 
> Since this is identical to that patchset:
> 
> Tested-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>

Thanks! Much appreciated.

Regards,

	Hans

> 
> Thanks!
> 
> On Mon, Feb 17, 2014 at 10:57 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> This patch series adds support for complex controls (aka 'Properties') to
>> the control framework and uses them in the go7007 and solo6x10 drivers.
>> It is the first part of a larger patch series that adds support for configuration
>> stores and support for 'Multiple Selections'.
>>
>> This patch series is identical to the REVIEWv2 series:
>>
>> http://www.spinics.net/lists/linux-media/msg72748.html
>>
>> except that patches 35-40 have been folded into the main series (except for patch
>> 40 which is added as a new patch since it is a standalone bug fix).
>>
>> If there are no more objections, then I am going to make a pull request for this
>> in one week time.
>>
>> I will post a pull request based on this series today as well.
>>
>> Regards,
>>
>>         Hans
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

