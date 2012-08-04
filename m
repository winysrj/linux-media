Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33997 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab2HDRmA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 13:42:00 -0400
References: <501D4535.8080404@lockie.ca>
In-Reply-To: <501D4535.8080404@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: boot slow down
From: Andy Walls <awalls@md.metrocast.net>
Date: Sat, 04 Aug 2012 13:42:09 -0400
To: James <bjlockie@lockie.ca>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Message-ID: <f1bd5aea-00cd-4b3f-9562-d25153f8cef3@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James <bjlockie@lockie.ca> wrote:

>There's a big pause before the 'unable'
>
>[    2.243856] usb 4-1: Manufacturer: Logitech
>[   62.739097] cx25840 6-0044: unable to open firmware
>v4l-cx23885-avcore-01.fw
>
>
>I have a cx23885
>cx23885[0]: registered device video0 [v4l2]
>
>Is there any way to stop it from trying to load the firmware?
>What is the firmware for, analog tv? Digital works fine and analog is
>useless to me.
>I assume it is timing out there.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

The firmware is for the analog broadcast audio standard (e.g. BTSC) detection microcontroller.

The A/V core of the CX23885/7/8 chips is for analog vidoe and audio processing (broadcast, CVBS, SVideo, audio L/R in).

The A/V core of the CX23885 provides the IR unit and the Video PLL provides the timing for the IR unit.

The A/V core of the CX23888 provides the Video PLL which is the timing for the IR unit in the CX23888.

Just grab the firmware and be done with it.  Don't waste time with trying to make the cx23885 working properly but halfway.

Regards,
Andy
