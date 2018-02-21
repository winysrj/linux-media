Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54722 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753932AbeBUNRm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 08:17:42 -0500
Subject: Re: [PATCHv3 10/15] media-device.c: zero reserved fields
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
 <20180219103806.17032-11-hverkuil@xs4all.nl>
 <20180221124954.4tgygs34mpl3s2ze@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8c18e38e-11f4-3779-3767-f3001afec053@xs4all.nl>
Date: Wed, 21 Feb 2018 14:17:37 +0100
MIME-Version: 1.0
In-Reply-To: <20180221124954.4tgygs34mpl3s2ze@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/18 13:49, Sakari Ailus wrote:
> On Mon, Feb 19, 2018 at 11:38:01AM +0100, Hans Verkuil wrote:
>> MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
>> struct. Do so in media_device_setup_link().
>>
>> MEDIA_IOC_ENUM_LINKS didn't zero the reserved field of the media_links_enum
>> struct. Do so in media_device_enum_links().
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> If you haven't sent a pull request including your patch "media-device: zero
> reserved media_links_enum field", could you add it to the next version of
> this set (or the same pull request)?

It's folded into this patch. It made no sense to have that in a separate patch.

Regards,

	Hans
