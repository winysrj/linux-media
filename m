Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34800 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030184AbbFEOSm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 10:18:42 -0400
Message-ID: <5571AFBE.8050509@iki.fi>
Date: Fri, 05 Jun 2015 17:18:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>,
	Steven Toth <stoth@kernellabs.com>
CC: Linux-Media <linux-media@vger.kernel.org>,
	Peter Faulkner-Ball <faulkner-ball@xtra.co.nz>
Subject: Re: [PATCH][media] SI2168: Resolve unknown chip version errors with
 different HVR22x5 models
References: <CALzAhNW=Oei7_Nziozh3Mm+X_NNHvM5EdmPVPh9ajn5Aen9O2g@mail.gmail.com>	<557048EF.3040703@iki.fi>	<CAAZRmGw7NcDo8YJtYN5gC6DM23jtgqmGhhJUAa6VaEovX+qNdA@mail.gmail.com>	<CAAZRmGy_AwJfGzfDorx_=43xNQ3cB915GFnck-YJ0gu0W64xKw@mail.gmail.com>	<CALzAhNXWsv6O23yzRAx9L6TrKRvm9o7SdApsHjMgE3dpqUYpWA@mail.gmail.com> <CAAZRmGxtzq1qX=JKusF_A+_0od8sY8LO_kN-6ZWge2E7GMoweA@mail.gmail.com>
In-Reply-To: <CAAZRmGxtzq1qX=JKusF_A+_0od8sY8LO_kN-6ZWge2E7GMoweA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/2015 04:40 PM, Olli Salonen wrote:
> Hi Steven,
>
> It seems to me that that part of the code is identical to your driver, no?
>
> The media_tree driver:
>
> retval = saa7164_api_i2c_read(bus,
>                       msgs[i].addr,
>                       0 /* reglen */,
>                       NULL /* reg */, msgs[i].len, msgs[i].buf);
>
> It's exactly the same with a little bit different formatting.

And that looks correct.

But the patch which does not look correct, or is at least unclear, is that
[media] saa7164: Improvements for I2C handling
http://permalink.gmane.org/gmane.comp.video.linuxtv.scm/22211

First change does not have any effect as len should be zero in any case 
and memcpy() should do nothing.

Second change looks something that is likely wrong. There is some hack 
which increases data len. All that register len stuff is logically wrong 
- I2C adapter handles just bytes and should not know nothing about 
client register layout. OK, there is some exceptions (like af9035) where 
I2C firmware actually knows register layout for some strange reason.

So could you remove that patch and test?

Antti

-- 
http://palosaari.fi/
