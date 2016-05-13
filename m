Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31402 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbcEMJia (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 05:38:30 -0400
Subject: Re: [PATCH v2 1/2] vb2: core: Skip planes array verification if pb is
 NULL
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, david@unsolicited.net,
	linux-kernel@vger.kernel.org
References: <1463055292-25053-1-git-send-email-sakari.ailus@linux.intel.com>
 <1463055292-25053-2-git-send-email-sakari.ailus@linux.intel.com>
 <573599BF.4050708@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <5735A092.5000209@linux.intel.com>
Date: Fri, 13 May 2016 12:38:26 +0300
MIME-Version: 1.0
In-Reply-To: <573599BF.4050708@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On 05/12/2016 02:14 PM, Sakari Ailus wrote:
>> An earlier patch fixing an input validation issue introduced another
>> issue: vb2_core_dqbuf() is called with pb argument value NULL in some
>> cases, causing a NULL pointer dereference. Fix this by skipping the
>> verification as there's nothing to verify.
>>
>> Signed-off-by: David R <david@unsolicited.net>
>>
>> Use if () instead of ? :; it's nicer that way. Improve the comment in the
>> code as well.
> 
> This comment doesn't seem applicable to this patch.

Compared to the original patch. I can sure drop the comment as well,
it's not that important.

> 
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
