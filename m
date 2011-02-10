Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:23262 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab1BJKEw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 05:04:52 -0500
Message-ID: <4D53B892.6070405@maxwell.research.nokia.com>
Date: Thu, 10 Feb 2011 12:06:10 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Wang, Wen W" <wen.w.wang@intel.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Jozef Kruger <jozef.kruger@siliconhive.com>,
	"Kanigeri, Hari K" <hari.k.kanigeri@intel.com>,
	"Iyer, Sundar" <sundar.iyer@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Memory allocation in Video4Linux
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com> <A787B2DEAF88474996451E847A0AFAB7F264B7A4@rrsmsx508.amr.corp.intel.com> <D5AB6E638E5A3E4B8F4406B113A5A19A32F92445@shsmsx501.ccr.corp.intel.com> <201102090851.41789.hverkuil@xs4all.nl> <D5AB6E638E5A3E4B8F4406B113A5A19A32F92475@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <D5AB6E638E5A3E4B8F4406B113A5A19A32F92475@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Wang, Wen W wrote:
> Hi Hans,
> 
> Thanks for your point and videobuf2 is also what I want to use.
> 
> But since our development kernel version right now is still 2.6.35, I
> need to find way to work with current videobuf framework.

Hi Wen,

If you're bound to use that kernel version, then one option to consider
might be backporting the videobuf2 to that kernel. 2.6.35 isn't so old.
You'd save work by not implementing the buffer handling on your own AND
also, you wouldn't later need to port the driver to use videobuf2.

I would suggest not to start using the old videobuf at this point. With
the current ISPs with their own MMUs it really does more harm than good.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
