Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59477 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1LITIj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 14:08:39 -0500
Message-ID: <4EE25CB4.3000501@iki.fi>
Date: Fri, 09 Dec 2011 21:08:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi> <4EE25A3C.9040404@redhat.com>
In-Reply-To: <4EE25A3C.9040404@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2011 08:58 PM, Mauro Carvalho Chehab wrote:
> On 09-12-2011 16:26, Antti Palosaari wrote:
>> On 12/09/2011 08:20 PM, Mauro Carvalho Chehab wrote:
>>> The DRX-K doesn't change the delivery system at set_properties,
>>> but do it at frontend init. This causes problems on programs like
>>> w_scan that, by default, opens both frontends.
>>>
>>> Instead, explicitly set the format when set_parameters callback is
>>> called.
>>
>> May I ask why you don't use mfe_shared flag instead?
>
> Tested with it. Works. It takes a little more time to switch, but the
> solution will be cleaner. version 2 will follow.

Yes, there is kind of loop timer which tries to take FE and swithing 
takes second or two because it waits FE is freed. I looked it when I did 
MFE and I did not understood why it was done like that.

cxd2820r has earlier simple lock (inside of demod driver) that just 
returned error immediately when busy. It is a little bit mystery for me 
why mfe_shared has that kind of waiting mechanism. Could someone explain 
reason for that?

regards
Antti

-- 
http://palosaari.fi/
