Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38958 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbcDOQtF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 12:49:05 -0400
Subject: Re: tvp5150 regression after commit 9f924169c035
To: Tony Lindgren <tony@atomide.com>
References: <20160212234623.GB3500@atomide.com>
 <56BE993B.3010804@osg.samsung.com> <20160412223254.GK1526@katana>
 <570ECAB0.4050107@osg.samsung.com> <20160414111257.GG1533@katana>
 <570F9DF1.3070700@osg.samsung.com> <20160414141945.GA1539@katana>
 <570FA8D6.5070308@osg.samsung.com> <20160414151244.GM5973@atomide.com>
 <57102EE3.3020707@osg.samsung.com> <20160415145828.GT5973@atomide.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	=?UTF-8?Q?Agust=c3=ad_Fontquerni?= <af@iseebcn.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <57111B76.8020106@osg.samsung.com>
Date: Fri, 15 Apr 2016 12:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <20160415145828.GT5973@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tony,

On 04/15/2016 10:58 AM, Tony Lindgren wrote:
>>
>>> The short term workaround is to mux the reset pin to use the internal
>>> pulls by using PIN_INPUT_PULLUP | MUX_MODE7, or depending on the direction,
>>> PIN_INPUT_PULLDOWN | MUX_MODE7.
>>
>> I guess you meant MUX_MODE4 here since the pin has to be in GPIO mode?
> 
> No, the glitch affects the GPIO mode, so that's why direction + pull +
> safe mode is needed.
>

Ah ok, thanks for the explanation and sorry for the confusion.
 
>> Also, I wonder how the issue could be related to the GPIO controller
>> since is when enabling runtime PM for the I2C controller that things
>> fail. IOW, disabling runtime PM for the I2C adapter shouldn't make
>> things to work if the problem was caused by the mentioned GPIO errata.
> 
> If you block PM runtime for I2C, then it blocks deeper idle states
> for the whole device. Note that you can disable off mode during idle

Thanks again for this clarification.

> and suspend with:
> 
> # echo 0 > /sys/kernel/debug/pm_debug/enable_off_mode
>

I see thought that enable_off_mode is 0 by default when booting the board:

# cat /sys/kernel/debug/pm_debug/enable_off_mode 
0

So if I understood your explanation correctly, that means that the glitch
should not happen for the GPIO pins since the machine doesn't enter into
deeper idle states that could cause the glitch from erratum 1.158?
 
>> In any case, I've tried to use the internal pulls as you suggested but
>> that didn't solve the issue.
> 
> OK. Just to be sure.. Did you use the safe mode mux option instead
> of the GPIO mux option?
>

No sorry, I tested with the GPIO mux mode before since I misunderstood
your previous email. But now I've tested with safe mode mux and didn't
make a difference (which was expected since off mode is disabled AFAIU). 
 
> Note that in some cases the internal pull is not strong enough to
> keep the reset line up if there's an external pull down resistor.
>

Yes, I got that from your previous email but as I mentioned, the lines
in the board don't have external pull resistors.
 
> Regards,
> 
> Tony
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
