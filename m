Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab3IIMJz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 08:09:55 -0400
Message-ID: <522DBA8F.4090505@redhat.com>
Date: Mon, 09 Sep 2013 14:09:51 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Frank Dierich <frank.dierich@googlemail.com>
CC: linux-media@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [Bug] 0ac8:0321 Vimicro generic vc0321 Camera is not working
 and causes crashes since 3.2
References: <522C618E.6020203@googlemail.com>
In-Reply-To: <522C618E.6020203@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/08/2013 01:37 PM, Frank Dierich wrote:
> Hi,
>
> I have an ASUS A8JP Notebook with Ubuntu 12.04 with the following build in webcam
>
>      Bus 001 Device 004: ID 0ac8:0321 Z-Star Microelectronics Corp. Vimicro generic vc0321 Camera
>
> The camera is working nice with Cheese and kernels before 3.2. I have tested the following once 2.6.32.61, 2.6.33.20, 2.6.34.11, 2.6.35.14, 2.6.36.4, 2.6.37.6, 2.6.38.8, 2.6.39.4, 3.0.94, 3.1.10. In all later kernels I have tested (3.2.50, 3.4.60, 3.10.10, 3.11.0) Cheese shows for some seconds a green and noisy image and crashes then with a segmentation fault.
>
> On the web I found some bug reports very similar to my problem but no one of these leads to a solution.
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=677533
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/990749
>
> In the following i give some informations about my system which hopefully helps to find the problem.

Thanks for the bug report, looking at the bug reports, they all report an error of -71 which is
EPROTO, which typically means something is wrong at the USB level.

And nothing has changed for the driver in question between 3.1 and 3.2 , so I believe this regression
is caused by changes to the usb sub-system, likely changes to the EHCI driver.

The best way forward with this is probably to bisect the problem, and then send a mail
to linux-usb@vger.kernel.org about this. Please CC me on this mail.

Regards,

Hans
