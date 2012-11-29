Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab2K2OZr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 09:25:47 -0500
Message-ID: <50B770E7.8020509@redhat.com>
Date: Thu, 29 Nov 2012 15:27:51 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yuri Glushkov <yglushkov@yahoo.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"525959@bugs.launchpad.net" <525959@bugs.launchpad.net>
Subject: Re: 093a:2460 Webcam (Pixart PAC207BCA) - inverted LED logic
References: <1353598043.25176.YahooMailNeo@web113301.mail.gq1.yahoo.com>
In-Reply-To: <1353598043.25176.YahooMailNeo@web113301.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 11/22/2012 04:27 PM, Yuri Glushkov wrote:
> [1.] One line summary of the problem:
> 093a:2460 Webcam (Pixart PAC207BCA) - inverted LED logic
>
> [2.] Full description of the problem/report:
> The LED on this webcam is always turned on when connected to USB, unless
>   some application uses it - the behavior that is opposite to what is
> expected.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/525959
> The problem persists on all versions of Ubuntu I've tested.

I've a webcam with the same usb-id where the LED is not inverted, so
I'm afraid that it is impossible to tell from the driver side if
the led is inverted or not.

Therefor I've written a patch for the gspca_pac207 driver which adds
a led_invert module parameter, when you set this to 1, it will
invert the turning on/off of the led.

You can find the patch for this here:
http://git.linuxtv.org/hgoede/gspca.git/commitdiff/8806976535f7da2ed1d93bc1230d68e5ca1acd9d

This patch should make it into 3.8.

Regards,

Hans
