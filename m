Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53554 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZHQUKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 16:10:10 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"khilman@deeprootsystems.com" <khilman@deeprootsystems.com>
Date: Mon, 17 Aug 2009 15:10:04 -0500
Subject: RE: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
 capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40145300E82@dlee06.ent.ti.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
 <200908151409.44219.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40145300B49@dlee06.ent.ti.com>
 <200908172046.34453.hverkuil@xs4all.nl>
In-Reply-To: <200908172046.34453.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Would you like the architecture specific changes against v4l-dvb linux-next tree or linux-davinci ? I will rework both the vpfe and vpif patches as per your comment.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Monday, August 17, 2009 2:47 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; davinci-linux-open-
>source@linux.davincidsp.com; khilman@deeprootsystems.com
>Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
>capture driver
>
>On Monday 17 August 2009 16:52:20 Karicheri, Muralidharan wrote:
>> Hans,
>>
>> They are applied against davinci tree (also mentioned in the patch).
>General procedure what I follow is to create platform code against davinci
>tree and v4l patches against v4l-dvb linux-next tree. The architecture part
>of linux-next is not up to date.
>>
>> Davinci tree is at
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git
>
>I must have missed the mention of this tree.
>
>I have a problem, though, as the current v4l-dvb repository doesn't compile
>against the linux-davinci git tree. And the only way I can get it to
>compile
>is to apply all five patches first.
>
>However, the whole tree should still compile after each patch is applied.
>And
>that goes wrong with your second patch where the Kconfig and Makefile are
>modified when the new sources aren't even added yet!
>
>What I would like to see is a patch series that starts with one patch that
>makes the current v4l-dvb tree compile again, then the arch patch is added,
>then a series of v4l-dvb patches in such an order that everything compiles
>after each step.
>
>Merging this is already complicated enough without breaking compilation in
>this way.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

