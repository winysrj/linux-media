Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55933 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbCPIyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 04:54:35 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NLA00COHRLKSY10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Mar 2015 08:58:32 +0000 (GMT)
Message-id: <55069A45.2020105@samsung.com>
Date: Mon, 16 Mar 2015 09:54:29 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 11/11] Add a libv4l plugin for Exynos4 camera
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-12-git-send-email-j.anaszewski@samsung.com>
 <5505D874.4060004@googlemail.com>
In-reply-to: <5505D874.4060004@googlemail.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2015 08:07 PM, Gregor Jasny wrote:
> On 21/11/14 17:14, Jacek Anaszewski wrote:
>
>> diff --git a/lib/Makefile.am b/lib/Makefile.am
>> index 3a0e19c..56b3a9f 100644
>> --- a/lib/Makefile.am
>> +++ b/lib/Makefile.am
>> @@ -5,7 +5,12 @@ SUBDIRS = \
>>   	libv4l2rds \
>>   	libv4l-mplane
>>
>> +if WITH_V4LUTILS
>> +SUBDIRS += \
>> +	libv4l-exynos4-camera
>> +endif
>
> Why do you depend on WITH_V4LUTILS for a libv4l plugin? This looks
> wrong. WITH_V4LUTILS is intended to only switch off the utilities in
> utils (see root Makefile.am).

This is an issue to be resolved. I need to depend on WITH_V4LUTILS,
because the plugin depends on utils' libraries (e.g. libmediactl.so and
lib4lsubdev.so). On the other hand some utils depend on core libs.

Temporarily the libv4-exynos4-camera plugin doesn't link against utils
libraries but has their sources compiled-in to avoid cyclic
dependencies. I submit this as a subject for discussion on how to adjust
the build system to handle such a configuration.


-- 
Best Regards,
Jacek Anaszewski
