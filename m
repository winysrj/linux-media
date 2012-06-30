Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3063 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402Ab2F3Kmh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 06:42:37 -0400
Date: Sat, 30 Jun 2012 12:42:29 +0200
Message-ID: <4FC4F2480000D990@mta-nl-1.mail.tiscali.sys>
In-Reply-To: <C73E570AC040D442A4DD326F39F0F00E15ACD0E4F5@SAPHIR.xi-lite.lan>
From: cedric.dewijs@telfort.nl
Subject: Betr: RE: dib0700 can't enable debug messages
To: "Olivier GRENIE" <olivier.grenie@parrot.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>-- Oorspronkelijk bericht --
>From: Olivier GRENIE <olivier.grenie@parrot.com>
>To: "cedric.dewijs@telfort.nl" <cedric.dewijs@telfort.nl>,
>	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
>Date: Fri, 29 Jun 2012 15:25:00 +0100
>Subject: RE: dib0700 can't enable debug messages
>
>
>Hello,
>did you enable the DVB USB debugging (CONFIG_DVB_USB_DEBUG) in your kernel
>configuration?
>
>regards,
>Olivier
>

Hi Olivier,

I have used the basic instructions from here, I think CONFIG_DVB_USB_DEBUG
is not set.
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

git clone git://linuxtv.org/media_build.git
cd media_build 
./build
su
make install
make unload
and then the modprobe commands.

I am not at my devel machine now, so I can't test now. I will try enabling
the debug symbol.

Thanks,
Cedric

       



