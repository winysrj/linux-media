Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:42521 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729376AbeKTBXE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 20:23:04 -0500
Subject: Re: [PATCH v4 6/6] media: video-i2c: support runtime PM
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
 <1540045588-9091-7-git-send-email-akinobu.mita@gmail.com>
 <bc0c9149-b3d9-b10e-a715-674d39edc5d5@xs4all.nl>
Message-ID: <a2f9e3df-ccb4-77be-05d3-1a993d86543a@xs4all.nl>
Date: Mon, 19 Nov 2018 15:59:11 +0100
MIME-Version: 1.0
In-Reply-To: <bc0c9149-b3d9-b10e-a715-674d39edc5d5@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/19/2018 03:26 PM, Hans Verkuil wrote:
> On 10/20/2018 04:26 PM, Akinobu Mita wrote:
>> AMG88xx has a register for setting operating mode.  This adds support
>> runtime PM by changing the operating mode.
>>
>> The instruction for changing sleep mode to normal mode is from the
>> reference specifications.
>>
>> https://docid81hrs3j1.cloudfront.net/medialibrary/2017/11/PANA-S-A0002141979-1.pdf
>>
>> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Hans Verkuil <hansverk@cisco.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Reviewed-by: Matt Ranostay <matt.ranostay@konsulko.com>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

For the record: I've accepted patches 1-5, so no need to repost the whole series,
just this patch needs an update.

Regards,

	Hans
