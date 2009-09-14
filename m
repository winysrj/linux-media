Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60489 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278AbZINU0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 16:26:03 -0400
MIME-Version: 1.0
In-Reply-To: <9b2b86520909140920y293a2a72lc369340a0f823970@mail.gmail.com>
References: <200909141730.40467.baeckham@gmx.net>
	 <9b2b86520909140920y293a2a72lc369340a0f823970@mail.gmail.com>
Date: Mon, 14 Sep 2009 16:26:04 -0400
Message-ID: <30353c3d0909141326x6e81b2er77e738bc532ae7ed@mail.gmail.com>
Subject: Re: parameter for module gspca_sn9c20x
From: David Ellingsworth <david@identd.dyndns.org>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: baeckham@gmx.net, linux-modules <linux-modules@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 14, 2009 at 12:20 PM, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> [CC linux-media]  The linux-modules list is for the program "modprobe"
> etc, not the actual kernel drivers.
>
> On 9/14/09, baeckham@gmx.net <baeckham@gmx.net> wrote:
>> I have a built-in webcam in my laptop: 0c45:624f Microdia PC Camera
>> (SN9C201)
>>
>> Till today I used the driver from [groups.google.de] to make it work.
>> But now I found the driver in the 2.6.31 kernel:
>>
>>        gspca_sn9c20x
>>
>> Unfortunately I have to flip the image vertically so it is displayed right,
>> otherwise it is upside-
>> down.
>>
>> With the google-groups-driver I had to use the parameter vflip=1 to flip the
>> image. But with the
>> kernel module gspca_sn9c20x this is not working:
>>
>> # modprobe gspca_sn9c20x vflip=1
>> FATAL: Error inserting gspca_sn9c20x
>> (/lib/modules/2.6.31/kernel/drivers/media/video/gspca/gspca_sn9c20x.ko):
>> Unknown symbol in module,
>> or unknown parameter (see dmesg)
>>
>> Does anyone know how to flip the image?

You might want to take a look at libv4l. Several cameras, like yours
are known to have the sensor mounted upside down. Kernel drivers
typically do not correct for this since it's impossible for the driver
to know if the sensor is upside down or not on all supported devices.
>From what I recall, libv4l does a couple of checks to determine if the
sensor is upside down or not and corrects the image if necessary. It
might also provide additional controls that allow you to flip the
image even if it's not a sensor that's known to be mounted upside
down. libv4l is compatible with all v4l2 applications simply by
pre-loading the library for the application using LDPRELOAD.

Regards,

David Ellingsworth
