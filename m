Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:63770 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZHPFZl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 01:25:41 -0400
Message-ID: <4A879851.9060103@freemail.hu>
Date: Sun, 16 Aug 2009 07:25:37 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: =?UTF-8?B?SmVhbi1GcmFuw6dvaXMgTW9pbmU=?= <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: libv4l: problem with 2x downscaling + Labtec Webcam 2200
References: <4A865B7A.7010208@freemail.hu> <4A867A40.8020404@hhs.nl>
In-Reply-To: <4A867A40.8020404@hhs.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

Hans de Goede wrote:
> On 08/15/2009 08:53 AM, Németh Márton wrote:
>> I am using your libv4l 0.6.0 [1] together with the driver gspca_pac7311
>> from Linux kernel 2.6.31-rc4 and with Labtec Webcam 2200 hardware [2]. I
>> am using the svv.c [3] to display the webcam image.
>>
>> When I'm using the webcam in 640x480 the image is displayed correctly.
>> However, when I set the resolution to 320x240, the image is not correct:
>> the image contains horizontal lines and doubled vertically. I guess the
>> conversion from 640x480 is not done just the pixels are shown as it would
>> be 320x240.
> 
> This is a known problem in 0.6.0 fixed by this commit:
> http://linuxtv.org/hg/~hgoede/libv4l/rev/89fba654c7ea
> 
> You can get a snapshot of what will eventually
> (soonish) become 0.6.1 here:
> http://people.atrpms.net/~hdegoede/libv4l-0.6.1-test.tar.gz
> 
> Upgrading to this should fix your problems.

Thanks, the libv4l 0.6.1-test fixed the problem for me.

Regards,

	Márton Németh
