Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:28284 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZGTJIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 05:08:42 -0400
Message-ID: <4A643408.2020408@nokia.com>
Date: Mon, 20 Jul 2009 12:08:24 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
Reply-To: sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
To: John Sarman <johnsarman@gmail.com>
CC: Sergio Aguirre <saaguirre@ti.com>,
	"Toivonen Tuukka.O (Nokia-D/Oulu)" <tuukka.o.toivonen@nokia.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Help bringing up a sensor driver for isp omap34xx.c
References: <bb2708720907151444l3a93bcb3y75d227c4828ec311@mail.gmail.com>
In-Reply-To: <bb2708720907151444l3a93bcb3y75d227c4828ec311@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Dropped Sameer and Mohit from Cc.)

John Sarman wrote:
> Hello,

Hi,

>    I am having a problem deciphering what is wrong with my sensor
> driver.  It seems that everything operates on the driver but that I am
> getting buffer overflows.  I have fully tested the image sensor and it
> is set to operate in 640x480 mode. currently it is like 648x 487 for
> the dummy pixels and lines.  I have enabled all the debugging #defines
> in the latest code from the gitorious repository.  I also had to edit
> a few debug statements because they cause the compile to fail. Those
> failures were due to the resizer rewrite and since the #defines were
> commented out that code was never compiled.  Anyways here is my dmesg
> after I open and select the /dev/video0.
> 
> I have been banging my head against a wall for 2 weeks now.
> 
> Thanks,

...

ISPSBL_PCR_CCDCPRV_2_RSZ_OVF very often without any ill effects (AFAIR) 
which consequently causes OVF_IRQ to be triggered. It can be ignored.

How are your images? :) Printing things that big from the interrupt 
handler might hamper with your image captuting efforts, too.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
