Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:37044 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZH3S2M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 14:28:12 -0400
Date: Sun, 30 Aug 2009 20:28:04 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Sudipto Sarkar <xtremethegreat1@gmail.com>
Cc: linux-media@vger.kernel.org,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>
Subject: Re: HP VGA Cam
Message-ID: <20090830202804.66f9b815@tele>
In-Reply-To: <4A9A66B0.10202@gmail.com>
References: <4A9A66B0.10202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 30 Aug 2009 17:16:56 +0530
Sudipto Sarkar <xtremethegreat1@gmail.com> wrote:

> I'm trying to write a driver for the HP VGA camera. USB ID:
> 15b8:6002. The sensor is 7131r, and the bridge is probably vc0323
> (although the inf says it's vc0326). It's inf is the same inf which
> includes the po1200 sensor, which was added in December last year
> (The HP 2.0 Megapixel camera). I am trying to use usbsnoop in a
> windows installation, but the log size just does not cease to come to
> a halt (as is specified in the microdia site), thereby leaving me
> unable to snoop the init sequence. What might be wrong?
> 
> Also, is this the same sensor as hv7131r, as in vc032x.c?

Hello Sudipto,

Did you try the last gspca v2 from my test repository? As there is a
probe sequence in the vc032x subdriver, the kernel log should contain
the sensor name. What is it? If you cannot get images, may you tell me
what is wrong? (does 'svv' display some image? does 'svv -rg' create a
raw image? what are the last kernel messages? ...)

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
