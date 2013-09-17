Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39782 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3IQSZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 14:25:22 -0400
Message-ID: <52389E8E.3050202@googlemail.com>
Date: Tue, 17 Sep 2013 20:25:18 +0200
From: Frank Dierich <frank.dierich@googlemail.com>
MIME-Version: 1.0
To: linux-usb <linux-usb@vger.kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: Re: [Bug] 0ac8:0321 Vimicro generic vc0321 Camera is not working
 and causes crashes since 3.2
References: <522C618E.6020203@googlemail.com> <522DBA8F.4090505@redhat.com> <522F6378.8000808@googlemail.com>
In-Reply-To: <522F6378.8000808@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On 09/09/2013 02:09 PM, Hans de Goede wrote:
>> Thanks for the bug report, looking at the bug reports, they all 
>> report an error of -71 which is
>> EPROTO, which typically means something is wrong at the USB level.
>>
>> And nothing has changed for the driver in question between 3.1 and 
>> 3.2 , so I believe this regression
>> is caused by changes to the usb sub-system, likely changes to the 
>> EHCI driver.
I have tested the new 3.12.0-rc1 kernel and the regression is still 
present. It causes that Cheese crashes with a segmentation fault and I 
get the following errors

[  139.868628] gspca_main: ISOC data error: [21] len=0, status=-71
[  139.904620] gspca_main: ISOC data error: [12] len=0, status=-71
[  139.936595] gspca_main: ISOC data error: [9] len=0, status=-71
[  139.968576] gspca_main: ISOC data error: [17] len=0, status=-71
[  140.036571] gspca_main: ISOC data error: [16] len=0, status=-71
[  140.037364] video_source:sr[2570]: segfault at 8 ip 00007f0430d6868c 
sp 00007f0406c02900 error 4 in 
libgstreamer-0.10.so.0.30.0[7f0430d15000+de000]
[  140.068533] gspca_main: ISOC data error: [24] len=0, status=-71
[  140.104519] gspca_main: ISOC data error: [15] len=0, status=-71
[  140.168474] gspca_main: ISOC data error: [20] len=0, status=-71
[  140.200461] gspca_main: ISOC data error: [28] len=0, status=-71

Frank
