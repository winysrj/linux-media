Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab3LOOpJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 09:45:09 -0500
Message-ID: <52ADC066.9080402@redhat.com>
Date: Sun, 15 Dec 2013 15:44:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, luca.risolia@linux-projects.org
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/2] sn9c102: prepare for removal by moving it to
 staging.
References: <1386850822-3487-1-git-send-email-hverkuil@xs4all.nl> <1386850822-3487-2-git-send-email-hverkuil@xs4all.nl> <1628977.YDkQVgTYrx@laptop> <52AD8FF9.2020901@xs4all.nl>
In-Reply-To: <52AD8FF9.2020901@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/15/2013 12:18 PM, Hans Verkuil wrote:

<snip>

> 4) Send the webcams that are not (or not correctly) supported by gscpa to Hans
>     de Goede, and let him add support for them to gspca. I don't know if he
>     wants to, though. He may well decide that it is not worth it, although I
>     assume he would be willing to at least fix gspca for webcams that are not
>     correctly supported.

Or alternatively simply send patches to add support for those not supported
to gspca. This should be easy.

I've even added support for some a sensor not supported by gspca when a user
reported to me he wanted to use his webcam with gspca. Porting over the sn9c102
sensor init code to gspca is pretty easy, the only thing which has stopped me
from doing so is not having hardware access. Since in this case I had a user
willing to test I added the support.

> Note that AFAIK HdG has some of the webcams supported by both
> gspca and sn9c102, I'm assuming those are working fine with gspca.

Correct I've the following sn9c10x bayer chipset cams I use for testing:

Sweex WC001                     0c45:6005       sn9c101 tas5110c        ok
Hewi                            0c45:6007       sn9c101 tas5110d        ok
Trust spacecam 120              0c45:600d       sn9c101 pas106          ok
Sweex WC004                     0c45:6011       sn9c101 ov6650          ok
Qware EasyCam WB-001            0c45:6028       sn9c102 pas202          ok

Also note that there are 0 bug-reports from users having issues with the
gspca_sonixb driver.

Regards,

Hans
