Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55232 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZHOJEl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 05:04:41 -0400
Message-ID: <4A867A40.8020404@hhs.nl>
Date: Sat, 15 Aug 2009 11:05:04 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: =?UTF-8?B?SmVhbi1GcmFuw6dvaXMgTW9pbmU=?= <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: libv4l: problem with 2x downscaling + Labtec Webcam 2200
References: <4A865B7A.7010208@freemail.hu>
In-Reply-To: <4A865B7A.7010208@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2009 08:53 AM, Németh Márton wrote:
> Hello Hans,
>
> I am using your libv4l 0.6.0 [1] together with the driver gspca_pac7311
> from Linux kernel 2.6.31-rc4 and with Labtec Webcam 2200 hardware [2]. I
> am using the svv.c [3] to display the webcam image.
>
> When I'm using the webcam in 640x480 the image is displayed correctly.
> However, when I set the resolution to 320x240, the image is not correct:
> the image contains horizontal lines and doubled vertically. I guess the
> conversion from 640x480 is not done just the pixels are shown as it would
> be 320x240.
>

Hi,

This is a known problem in 0.6.0 fixed by this commit:
http://linuxtv.org/hg/~hgoede/libv4l/rev/89fba654c7ea

You can get a snapshot of what will eventually
(soonish) become 0.6.1 here:
http://people.atrpms.net/~hdegoede/libv4l-0.6.1-test.tar.gz

Upgrading to this should fix your problems.

Regards,

Hans
