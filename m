Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40043 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbZINQT7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 12:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <200909141730.40467.baeckham@gmx.net>
References: <200909141730.40467.baeckham@gmx.net>
Date: Mon, 14 Sep 2009 17:20:00 +0100
Message-ID: <9b2b86520909140920y293a2a72lc369340a0f823970@mail.gmail.com>
Subject: Re: parameter for module gspca_sn9c20x
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: baeckham@gmx.net
Cc: linux-modules <linux-modules@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[CC linux-media]  The linux-modules list is for the program "modprobe"
etc, not the actual kernel drivers.

On 9/14/09, baeckham@gmx.net <baeckham@gmx.net> wrote:
> I have a built-in webcam in my laptop: 0c45:624f Microdia PC Camera
> (SN9C201)
>
> Till today I used the driver from [groups.google.de] to make it work.
> But now I found the driver in the 2.6.31 kernel:
>
> 	 gspca_sn9c20x
>
> Unfortunately I have to flip the image vertically so it is displayed right,
> otherwise it is upside-
> down.
>
> With the google-groups-driver I had to use the parameter vflip=1 to flip the
> image. But with the
> kernel module gspca_sn9c20x this is not working:
>
> # modprobe gspca_sn9c20x vflip=1
> FATAL: Error inserting gspca_sn9c20x
> (/lib/modules/2.6.31/kernel/drivers/media/video/gspca/gspca_sn9c20x.ko):
> Unknown symbol in module,
> or unknown parameter (see dmesg)
>
> Does anyone know how to flip the image?

All I can say is it doesn't appear to be a module parameter, because
there aren't any module parameters in the mainline driver :-).

Regards
Alan
