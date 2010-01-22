Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60891 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab0AVQXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 11:23:09 -0500
Date: Fri, 22 Jan 2010 17:24:39 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?0JrQvtGB0YLRjyDQpNGR0LTQvtGA0L7Qsg==?=
	<ajaks2009@mail.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: libv24l ubuntu 9.10
Message-ID: <20100122172439.25e67b1c@tele>
In-Reply-To: <E1NY4os-0007Ki-00.ajaks2009-mail-ru@f278.mail.ru>
References: <E1NY4os-0007Ki-00.ajaks2009-mail-ru@f278.mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 22 Jan 2010 00:44:02 +0300
Костя Фёдоров  <ajaks2009@mail.ru> wrote:

> Ubuntu 9.10 operating system, web camera SAMSUNG PLEOMAX-PWC-3800
> 
> : ~ $ lsusb
> Bus 002 Device 002: ID 0ac8:0302 Z-Star Microelectronics Corp. ZC0302
> Webcam
> 
> I start Skype 2.1.0.81 LD_PRELOAD =/usr/lib/libv4l/v4l1compat.so skype
> command
> 
> Video black-and-white also is turned.
> 
> Thanks for support.

Hi,

There was a sensor detection problem in some kernels with zc3xx
webcams. May you get the last video stuff from LinuxTv.org and try it?

If it does not work, please, send me a mail with more information about
the sensor (last kernel messages after webcam connection).

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
