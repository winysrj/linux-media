Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52027 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966506AbcKXPjw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 10:39:52 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OH500B2EKUDWP40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2016 15:39:49 +0000 (GMT)
Subject: Re: [PATCH v4l-utils v7 4/7] mediactl: Add media_device creation
 helpers
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <01d05a40-ab67-1b9a-42ce-12f1e20ebb78@samsung.com>
Date: Thu, 24 Nov 2016 16:39:46 +0100
MIME-version: 1.0
In-reply-to: <20161124143226.GR16630@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-5-git-send-email-j.anaszewski@samsung.com>
 <CGME20161124121817epcas3p24fa27e9afedce6356c75bf3e63730432@epcas3p2.samsung.com>
 <20161124121731.GF16630@valkosipuli.retiisi.org.uk>
 <65435934-bbbd-83ac-b101-63244c1a5651@samsung.com>
 <20161124143226.GR16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2016 03:32 PM, Sakari Ailus wrote:
[...]
>>>> +	sprintf(device_dir_path, "/sys/class/video4linux/%s/device/", p + 1);
>>>> +
>>>> +	device_dir = opendir(device_dir_path);
>>>> +	if (device_dir == NULL)
>>>> +		return NULL;
>>>> +
>>>> +	while ((entry = readdir(device_dir))) {
>>>> +		if (strncmp(entry->d_name, "media", 4))
>>>
>>> Why 4? And isn't entry->d_name nul-terminated, so you could use strcmp()?
>>
>> Media devices, as other devices, have numerical postfix, which is
>> not of our interest.
>
> Right. But still 5 would be the right number as we should also check the
> last "a".

Of course, this needs to be fixed, thanks.

-- 
Best regards,
Jacek Anaszewski
