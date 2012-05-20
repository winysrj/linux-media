Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58074 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2ETJ42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 05:56:28 -0400
Received: by bkcji2 with SMTP id ji2so3241504bkc.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 02:56:27 -0700 (PDT)
Message-ID: <4FB8BFC9.2080704@googlemail.com>
Date: Sun, 20 May 2012 11:56:25 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, pomidorabelisima@gmail.com
Subject: Re: [PATCH v5 0/5] support for rtl2832
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com> <4FB6B55D.4060500@iki.fi>
In-Reply-To: <4FB6B55D.4060500@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.05.2012 22:47, Antti Palosaari wrote:
> Good evening!
> 
> On 18.05.2012 21:47, Thomas Mair wrote:
>> Good Evening!
>>
>> This is the corrected version of the patch series to support the
>> RTL2832 demodulator. There where no major changes. The majority of
>> the changes consist in fixing style issues and adhering to proper
>> naming conventions.
> 
> Review done and seems to be OK for my eyes.

Thanks Antti! You have been a big help for developing the driver.
What are the next steps? I think the fc0012 and fc0013 driver 
need to be reviewed before the patch may be included in 
staging. Is that the way it works?
 
>> The next question for me is how to proceed when including new
>> devices. Poma already sent an extensive list a little while
>> ago (http://patchwork.linuxtv.org/patch/10982/). Should they
>> all be included at once, or should I wait until somone confirms
>> they are working correctly and include them one by one?
> 
> It has been rule that device is added after known to work.
> 

That sounds good to me. In the meantime I will try to set up a 
page for the driver on the linuxtv.org wiki to keep information
about the driver and the devices in one place.

> Unfortunately DVB USB do not support dynamic USB ID. In order to workaround that I have done some small hackish solution for the dvb_usb_rtl28xxu driver. Currently it works for RTL2831U based devices, but I see it could be easily extended for RTL2832U too by adding module parameter.
> 

If I understand it right, the problem is that the tuner/demod 
combination is also hard coded in the dvb_usb_rtl28xxu driver?

> regards
> Antti

Regards
Thomas

