Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab1LIS6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 13:58:15 -0500
Message-ID: <4EE25A3C.9040404@redhat.com>
Date: Fri, 09 Dec 2011 16:58:04 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi>
In-Reply-To: <4EE252E5.2050204@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-12-2011 16:26, Antti Palosaari wrote:
> On 12/09/2011 08:20 PM, Mauro Carvalho Chehab wrote:
>> The DRX-K doesn't change the delivery system at set_properties,
>> but do it at frontend init. This causes problems on programs like
>> w_scan that, by default, opens both frontends.
>>
>> Instead, explicitly set the format when set_parameters callback is
>> called.
>
> May I ask why you don't use mfe_shared flag instead?

Tested with it. Works. It takes a little more time to switch, but the
solution will be cleaner. version 2 will follow.

Regards,
Mauro
