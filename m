Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:23216 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab1DFIEb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2011 04:04:31 -0400
Message-ID: <4D9C1E84.60606@maxwell.research.nokia.com>
Date: Wed, 06 Apr 2011 11:04:20 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: David Cohen <dacohen@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: [RFC] V4L2 API for flash devices
References: <4D90854C.2000802@maxwell.research.nokia.com> <BANLkTik9vSSRKYHj9cUGUzxFy_cpcVo7ZQ@mail.gmail.com>
In-Reply-To: <BANLkTik9vSSRKYHj9cUGUzxFy_cpcVo7ZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

David Cohen wrote:
> On Mon, Mar 28, 2011 at 3:55 PM, Sakari Ailus
> <sakari.ailus@maxwell.research.nokia.com> wrote:
>> Hi,
> 
> Hi Sakari,

Thanks for the comments, David!

> [snip]
> 
>> This is a bitmask containing the fault information for the flash. This
>> assumes the proposed V4L2 bit mask controls [5]; otherwise this would
>> likely need to be a set of controls.
>>
>> #define V4L2_FLASH_FAULT_OVER_VOLTAGE           0x00000001
>> #define V4L2_FLASH_FAULT_TIMEOUT                0x00000002
>> #define V4L2_FLASH_FAULT_OVER_TEMPERATURE       0x00000004
>> #define V4L2_FLASH_FAULT_SHORT_CIRCUIT          0x00000008
> 
> Sorry for bringing this a bit late.  As we already talked directly,
> IMO (1 << 0), (1 << 1), ... could have a better readability to expose
> how you want to define an expand these macros.

I'll change this to the next version of the RFC.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
