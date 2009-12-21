Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:40618 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZLUBnN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2009 20:43:13 -0500
Received: by qw-out-2122.google.com with SMTP id 3so948502qwe.37
        for <linux-media@vger.kernel.org>; Sun, 20 Dec 2009 17:43:13 -0800 (PST)
Message-ID: <4B2EFC5E.7040900@gmail.com>
Date: Sun, 20 Dec 2009 23:41:02 -0500
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Yves <ydebx6@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: Nova-T 500 Dual DVB-T
References: <4B2DDE8E.4090708@free.fr>
In-Reply-To: <4B2DDE8E.4090708@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Yves,

On 12/20/2009 03:21 AM, Yves wrote:
> Hi,
>
> I have a Nova-T 500 Dual DVB-T card that used to work very well under 
> Mandriva 2008.1 (kernel 2.6.24.7).
>
> I moved to Mandriva 2009.1, then 2010.0 (kernel 2.6.31.6) and it 
> doesn't work well any more. Scan can't find channels. I tried hading 
> "options dvb-usb-dib0700 force_lna_activation=1" in 
> /etc/modprobe.conf. It improve just a bit. Scan find only a few 
> channels. If I revert to Mandriva 2008.1 (in another partition), all 
> things are good (without adding anything in modprobe.conf).
>
> Is there a new version of the driver (dvb_usb_dib0700) that correct 
> this behavior.
> If not, how to install the driver from kernel 2.6.24.7 in kernel 
> 2.6.31.6 ?
>

Please try the current driver available at v4l/dvb develpment tree and 
share your results here.

hg clone http://linuxtv.org/hg/v4l-dvb
make
make rmmod
make install

Finally, just restart your machine and test your favourite application.

For additional info:

http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

Cheers,
Douglas
