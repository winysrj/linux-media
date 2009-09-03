Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbZICLKv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:10:51 -0400
Message-ID: <4A9FA4E3.8070304@hhs.nl>
Date: Thu, 03 Sep 2009 13:13:39 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Simon Farnsworth <simon.farnsworth@onelan.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl> <4A9F89AD.7030106@onelan.com> <4A9F9006.6020203@hhs.nl> <4A9F98BA.3010001@onelan.com>
In-Reply-To: <4A9F98BA.3010001@onelan.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2009 12:21 PM, Simon Farnsworth wrote:
> Hans de Goede wrote:
>> Ok,
>>
>> That was even easier then I thought it would be. Attached is a patch
>> (against libv4l-0.6.1), which implements 1) and 3) from above.
>>
> I applied it to a clone of your HG repository, and had to make a minor
> change to get it to compile. I've attached the updated patch.
>

Woopsie, sorry I should have test compiled it myself.

Regards,

Hans
