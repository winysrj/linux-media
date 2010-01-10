Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:47214 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab0AJTrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 14:47:31 -0500
Date: Sun, 10 Jan 2010 20:48:44 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_pac7302: sporatdic problem when plugging the device
Message-ID: <20100110204844.770f8fd7@tele>
In-Reply-To: <4B4A0752.6030306@freemail.hu>
References: <4B4A0752.6030306@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 10 Jan 2010 17:58:58 +0100
Németh Márton <nm127@freemail.hu> wrote:

> Then I plugged and unplugged the device 16 times. When I last plugged
> the device I get the following error in the dmesg:
> 
> [32393.421313] gspca: probing 093a:2626
> [32393.426193] gspca: video0 created
> [32393.426958] gspca: probing 093a:2626
> [32393.426968] gspca: Interface class 1 not handled here
> [32394.005917] pac7302: reg_w_page(): Failed to write register to
> index 0x49, value 0x0, error -71
> [32394.067799] gspca: set alt 8 err -71
> [32394.090792] gspca: set alt 8 err -71
> [32394.118159] gspca: set alt 8 err -71
> 
> The 17th plug was working correctly again. I executed this test on an
> EeePC 901.
> 
> This driver version contains the msleep(4) in the reg_w_buf().
> However, here the reg_w_page() fails, which does not have msleep()
> inside. I don't know what is the real problem, but I am afraid that
> slowing down reg_w_page() would make the time longer when the device
> can be used starting from the event when it is plugged.

Hi again,

I don't understand what you mean by:
> This driver version contains the msleep(4) in the reg_w_buf().
> However, here the reg_w_page() fails, which does not have msleep()
> inside.

Indeed the delay will slow down the webcam start (256 * 4 ms = 1s).

If having a delay fixes the problem, then, as the error always occurs
at the same index 0x49 (3 reports), a single delay could be set before
writing to this index. Do you want I code this for test?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
