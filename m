Return-path: <linux-media-owner@vger.kernel.org>
Received: from web35601.mail.mud.yahoo.com ([66.163.179.140]:39599 "HELO
	web35601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755533AbZJSNEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 09:04:53 -0400
Message-ID: <359919.55939.qm@web35601.mail.mud.yahoo.com>
References: <247901.47271.qm@web35605.mail.mud.yahoo.com> <20091019110317.4addddef@tele>
Date: Mon, 19 Oct 2009 06:04:58 -0700 (PDT)
From: Habib Seifzadeh <habibseifzadeh@yahoo.com>
Subject: Re: Genius iLook 300
To: linux-media@vger.kernel.org
In-Reply-To: <20091019110317.4addddef@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> > I bought a Genius iLook 300 webcam recently. After I discovered that
> > my linux (Ubuntu 8.10) can't detect it automatically, I downloaded
> > the latest gspca from
> > http://linuxtv.org/hg/~jfrancois/gspca/archive/tip.tar.gz link. It
> > was compiled without any problem but my computer can't still detect
> > the webcam...
>     [snip]
> 
> Hello Habib,
> 
> It seems that your webcam is 093a:2628 from Pixart and that it is close
> to the webcam 093a:2620. As you have the last gspca, may you add the
> line:
> 
>     {USB_DEVICE(0x093a, 0x2628), .driver_info = SENSOR_PAC7302},
> 
> after the line 1108 of pac7311.c (in linux/drivers/media/video/gspca/)
> and check if it works? (don't forget to regenerate and reinstall the
> drivers)
> 
> Regards.

Dear Jean,

I added the line you mentioned and reinstalled the package. Now, my camera works perfectly in linux. Thanks a lot. 
Even, restarting the computer is not required. Just reinstall the drivers and plugin the camera!!!

P.S: the device id is exactly the same as you said.

Sincerely,
Habib



      
