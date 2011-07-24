Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1GXRfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 13:35:09 -0400
Message-ID: <4E2C5826.6040109@redhat.com>
Date: Sun, 24 Jul 2011 19:36:38 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yordan Kamenov <ykamenov@mm-sol.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v4 1/1] libv4l: Add plugin support to libv4l
References: <1304436396-10501-1-git-send-email-ykamenov@mm-sol.com> <1678f1f41284ad9665de8717b7b8be117ddf9596.1304435825.git.ykamenov@mm-sol.com> <4E234D53.4030604@redhat.com> <4E2999C6.1090006@mm-sol.com>
In-Reply-To: <4E2999C6.1090006@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/22/2011 05:39 PM, Yordan Kamenov wrote:
> Hi Hans,
>
> Hans de Goede wrote:
>> Hi,
>>
>> Sorry it took so long, but I've just merged the plugin
>> support into v4l-utils git. I did make some minor mods /
>> bugfixes before merging, see the commit message in git.
>>
>> Regards,
>>
>> Hans
>>
>> p.s.
>>
>> I think we should expand the plugin support with support
>> for a output devices, iow add a write() dev_op. If you
>> guys agree I can easily do so myself, we should do this
>> asap before people start depending on the ABI
>> (although there is no ABI stability promise until I
>> release 0.10.x, see my message to the list wrt
>> the start of the 0.9.x cycle).
>>
>
> I think that it is a good point, you can add write() and
> reserved dev_ops.

Ok, done, this is in v4l-utils git master now.

Regards,

Hans
