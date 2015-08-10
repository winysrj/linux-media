Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33029 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbbHJWlF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 18:41:05 -0400
Subject: Re: dvb_usb_af9015: command failed=1 _ kernel >= 4.1.x
To: poma <pomidorabelisima@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>
References: <mhnd10gxck9p5yqwsxbonfty.1436213845281@email.android.com>
 <559B9261.4050409@gmail.com> <55A38988.80404@gmail.com>
 <55BB8E31.8030907@gmail.com>
 <CAAZRmGym49dG6Jj-ZeKZmy0rgr4ozph7-ggjLoWtGOvT1m4oBA@mail.gmail.com>
 <55C91BD1.9010807@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Jose Alberto Reguero <jareguero@telefonica.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55C92879.5020306@iki.fi>
Date: Tue, 11 Aug 2015 01:40:57 +0300
MIME-Version: 1.0
In-Reply-To: <55C91BD1.9010807@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2015 12:46 AM, poma wrote:
> Furthermore, to fix this issue - AF9015 DVB-T USB2.0 stick brokenness - is the responsibility of developers.
> I am here only proven tester.
>
> I hope we understand each other, and this problem will be resolved in good faith.

Your patches are implemented wrong.

When I added mxl5007t support to that driver it was DigitalNow TinyTwin 
v2 I had. The rest mxl5007t dual devices using reference design IDs went 
to same due to reason driver detects used tuner. My device is still 
working fine, which means your device has different wiring. As 2nd tuner 
attach fails it means there is communication loss to tuner. Which means 
tuner is most likely hold in a reset attach time or there is some I2C 
gating which prevents communication.

Patches you sent will introduce another issue. For dual tuner 
configuration there could be antenna wired from tuner chip to another. 
After that patch you will lose antenna signal from 2nd tuner on cases 
where tuner antenna wire is loop through master tuner to slave.

So fix it correctly. Find out reason there is communication loss to 2nd 
tuner on attach time. I cannot do much as I simply don't have such 
hardware. And I really do not care to take any responsibility when that 
kind of issues happens - it is not my job to bough every single device 
from the market in able to test and fix every hardware combination.


Antti

-- 
http://palosaari.fi/
