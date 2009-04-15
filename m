Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:59242 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbZDOW7E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 18:59:04 -0400
Message-ID: <49E66787.2080301@hhs.nl>
Date: Thu, 16 Apr 2009 01:02:31 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
References: <49E5D4DE.6090108@hhs.nl> <200904152326.59464.linux@baker-net.org.uk>
In-Reply-To: <200904152326.59464.linux@baker-net.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2009 12:26 AM, Adam Baker wrote:
> On Wednesday 15 Apr 2009, Hans de Goede wrote:
>> Currently only whitebalancing is enabled and only on Pixarts (pac) webcams
>> (which benefit tremendously from this). To test this with other webcams
>> (after instaling this release) do:
>>
>> export LIBV4LCONTROL_CONTROLS=15
>> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp&
>>
>
> Strangely while those instructions give me a whitebalance control for the
> sq905 based camera I can't get it to appear for a pac207 based camera
> regardless of whether LIBV4LCONTROL_CONTROLS is set.
>

Thats weird, there is a small bug in the handling of pac207
cams with usb id 093a:2476 causing libv4l to not automatically
enable whitebalancing (and the control) for cams with that id,
but if you have LIBV4LCONTROL_CONTROLS set (exported!) both
when loading v4l2ucp (you must preload v4l2convert.so!) and
when loading your viewer, then it should work.

>> Notice the whitebalance and normalize checkboxes in v4l2ucp,
>> as well as low and high limits for normalize.
>>
>> Now start your favorite webcam viewing app and play around with the
>> 2 checkboxes. Note normalize seems to be useless in most cases. If
>> whitebalancing makes a *strongly noticable* difference for your webcam
>> please mail me info about your cam (the usb id), then I can add it to
>> the list of cams which will have the whitebalancing algorithm (and the v4l2
>> control to enable/disable it) enabled by default.
>
> The whitebalance works really well with the sq905 (ID 2770:9120). Without it
> the image is very red when using artificial light, with auto whitebalance the
> colours look slightly desaturated but otherwise fine.
>

Good to hear it helps for the sq905 too, is that the only know id for sq905 cams ?

Regards,

Hans

> Adam
>

