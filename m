Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:30703 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZGTKxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 06:53:05 -0400
Received: by an-out-0708.google.com with SMTP id d40so3478346and.1
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 03:53:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A643408.2020408@nokia.com>
References: <bb2708720907151444l3a93bcb3y75d227c4828ec311@mail.gmail.com>
	 <4A643408.2020408@nokia.com>
Date: Mon, 20 Jul 2009 06:53:03 -0400
Message-ID: <bb2708720907200353w783c115alee7c4df997d7c6c6@mail.gmail.com>
Subject: Re: Help bringing up a sensor driver for isp omap34xx.c
From: John Sarman <johnsarman@gmail.com>
To: sakari.ailus@maxwell.research.nokia.com,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,
My images are not so pretty yet, but that is because I haven't set any
real configuration on the image sensor yet.  First I would like to get
the data streaming to the framebuffer. That will allow me to focus the
image, then I will start applying the i2c calls needed.   Also I have
an idea for creating a sensor driver, one to rule them all so to
speak.  What are your opinions on a driver that would read a firmware
file that basically contains the i2c calls that are sensor specific.
In the firmware block it would have the necessary code to first find
the sensor, then it would have blocks to do the various sensor related
features, such as init ,gain, exposure , etc, etc.  This model would
allow for anyone to use an image sensor with confidential datasheets
because they could place there firmware in say /lib/firmware/imaging
and not be forced to have that GPL'ed.  Plus everyone benefits from a
highly tested GPL'ed driver.  I even image a tool that allows
designers to generate the firmware files while viewing the data on the
framebuffer, but thats a future discussion.

Thanks,
John Sarman

On Mon, Jul 20, 2009 at 5:08 AM, Sakari Ailus<sakari.ailus@nokia.com> wrote:
> (Dropped Sameer and Mohit from Cc.)
>
> John Sarman wrote:
>>
>> Hello,
>
> Hi,
>
>>   I am having a problem deciphering what is wrong with my sensor
>> driver.  It seems that everything operates on the driver but that I am
>> getting buffer overflows.  I have fully tested the image sensor and it
>> is set to operate in 640x480 mode. currently it is like 648x 487 for
>> the dummy pixels and lines.  I have enabled all the debugging #defines
>> in the latest code from the gitorious repository.  I also had to edit
>> a few debug statements because they cause the compile to fail. Those
>> failures were due to the resizer rewrite and since the #defines were
>> commented out that code was never compiled.  Anyways here is my dmesg
>> after I open and select the /dev/video0.
>>
>> I have been banging my head against a wall for 2 weeks now.
>>
>> Thanks,
>
> ...
>
> ISPSBL_PCR_CCDCPRV_2_RSZ_OVF very often without any ill effects (AFAIR)
> which consequently causes OVF_IRQ to be triggered. It can be ignored.
>
> How are your images? :) Printing things that big from the interrupt handler
> might hamper with your image captuting efforts, too.
>
> Cheers,
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>
