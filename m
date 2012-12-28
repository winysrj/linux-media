Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:59913 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab2L1Nqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 08:46:52 -0500
Received: by mail-ob0-f172.google.com with SMTP id za17so9739552obc.17
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 05:46:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201212281124.51772.hverkuil@xs4all.nl>
References: <1352703366.5567.18.camel@linux>
	<201212281124.51772.hverkuil@xs4all.nl>
Date: Fri, 28 Dec 2012 16:23:13 +0300
Message-ID: <CALW4P+KAWBxk658qnMFQCrPYUCD4pHoY4n3sPVDzmNVvwn=JJA@mail.gmail.com>
Subject: Re: [patch 00/03 v2] driver for Masterkit MA901 usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dougsland@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Dec 28, 2012 at 2:24 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Mon November 12 2012 07:56:06 Alexey Klimov wrote:
>> Hi all,
>>
>> This is second version of small patch series for ma901 usb radio driver.
>> Initial letter about this usb radio was sent on October 29 and can be
>> found here: http://www.spinics.net/lists/linux-media/msg55779.html
>>
>> Changes:
>>         - removed f->type check and set in vidioc_g_frequency()
>>         - added maintainers entry patch
>
> For the whole patch series:
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> PS: Sorry for the late reply. The 'Date:' line of these emails was November 12, but
> they were sent on November 27! So my email client sorted them way down in the list,
> out of sight. You might want to check the date in the future...

Sorry!..
It looks like i sent them from odroid-x arm board that i use to play
with and test usb radio devices that i have.
This arm board doesn't have battery to save RTC time and gentoo in
current configuration doesn't use NTP to update time from internet.

BTW, thanks!

-- 
Best regards, Klimov Alexey
