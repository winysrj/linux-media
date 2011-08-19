Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:39601 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1HSJcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 05:32:15 -0400
Date: Fri, 19 Aug 2011 11:32:18 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Damien Cassou <damien.cassou@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Image and webcam freeze on Ubuntu with Logitech QuickCam
 Communicate STX
Message-ID: <20110819113218.05e9cc34@tele>
In-Reply-To: <CA+y5ggjdGZsBSs7UOEpRnoOZh0C96_GOcnvNzmUNAcPo_LF0Lw@mail.gmail.com>
References: <CA+y5ggjdGZsBSs7UOEpRnoOZh0C96_GOcnvNzmUNAcPo_LF0Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Aug 2011 12:31:51 +0200
Damien Cassou <damien.cassou@gmail.com> wrote:

> my Logitech QuickCam Communicate STX works perfectly well for a few
> minutes when I use it. However, after that the image is frozen and I
> can't make it work again until I reboot the system (before rebooting,
> the webcam has a blue color indicating it is "working" even though I
> can't get anything displayed). What can I do? A way to avoid rebooting
> would be a very welcomed workaround.
> 
> Details below:
> 
> - because of this bug I compiled the driver manually to see if the bug
> was fixed. I compiled it from gspca-2.13.6.tar.gz
> 
> - ubuntu 11.04, all updates installed
> 
> - dmesg displays a lot of the following line:
> gspca: ISOC data error: [0] len=0, status=-18
> 
> - lsusb returns:
> Bus 003 Device 002: ID 046d:08ad Logitech, Inc. QuickCam Communicate STX

Hi Damien,

I need more information.

May you send me the kernel messages starting from the webcam connection
up to the first ISOC data errors? Please, use the gspca 2.13.6 and set
the debug level to 0x0f:

	echo 0x0f > /sys/module/gspca_main/parameters/debug

(then, unplug / replug the webcam)

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
