Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39457 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbZFJVbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:31:00 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Wed, 10 Jun 2009 16:30:57 -0500
Subject: RE: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE
 Capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A08E51@dlee06.ent.ti.com>
References: <1244573204-20391-1-git-send-email-m-karicheri2@ti.com>
 <200906102328.16328.hverkuil@xs4all.nl>
In-Reply-To: <200906102328.16328.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Great! I look forward for your comments.

Murali Karicheri
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Wednesday, June 10, 2009 5:28 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; davinci-linux-open-
>source@linux.davincidsp.com; Muralidharan Karicheri
>Subject: Re: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE
>Capture driver
>
>On Tuesday 09 June 2009 20:46:44 m-karicheri2@ti.com wrote:
>> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>>
>> VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446
>>
>> This is the version v2 of the patch series. This is the reworked
>> version of the driver based on comments received against the last
>> version of the patch.
>
>I'll be reviewing this Friday or Saturday.
>
>Regards,
>
>	Hans
>
>>
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> These patches add support for VPFE (Video Processing Front End) based
>> video capture on DM355 and DM6446 EVMs. For more details on the hardware
>> configuration and capabilities, please refer the vpfe_capture.c header.
>> This patch set consists of following:-
>>
>> Patch 1: VPFE Capture bridge driver
>> Patch 2: CCDC hw device header file
>> Patch 3: DM355 CCDC hw module
>> Patch 4: DM644x CCDC hw module
>> Patch 5: common types used across CCDC modules
>> Patch 6: Makefile and config files for the driver
>> Patch 7: DM355 platform and board setup
>> Patch 8: DM644x platform and board setup
>> Patch 9: Remove outdated driver files from davinci git tree
>> Patch 10: common vpss hw module for video drivers
>>
>> NOTE:
>>
>> Dependent on the TVP514x decoder driver patch for migrating the
>> driver to sub device model from Vaibhav Hiremath
>>
>> Following tests are performed.
>> 	1) Capture and display video (PAL & NTSC) from tvp5146 decoder.
>> 	   Displayed using fbdev device driver available on davinci git tree
>> 	2) Tested with driver built statically and dynamically
>>
>> Muralidhara Karicheri
>>
>> Reviewed By "Hans Verkuil".
>> Reviewed By "Laurent Pinchart".
>>
>> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

