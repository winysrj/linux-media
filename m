Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53682 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2HUR5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 13:57:14 -0400
Received: by lbbgj3 with SMTP id gj3so140883lbb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 10:57:12 -0700 (PDT)
Message-ID: <5033CBE8.9050508@iki.fi>
Date: Tue, 21 Aug 2012 20:56:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "M. Fletcher" <mpf30@cam.ac.uk>
CC: linux-media@vger.kernel.org
Subject: Re: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
References: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk> <5033A9C3.7090501@iki.fi> <00f401cd7fb2$d402c530$7c084f90$@cam.ac.uk> <5033AC22.608@iki.fi> <00f501cd7fb7$f93fc0a0$ebbf41e0$@cam.ac.uk> <5033B459.1020401@iki.fi> <00ff01cd7fc6$0487c030$0d974090$@cam.ac.uk>
In-Reply-To: <00ff01cd7fc6$0487c030$0d974090$@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2012 08:54 PM, M. Fletcher wrote:
> I appreciate all of your help.
>
> I found the following http://sdr.osmocom.org/trac/wiki/rtl-sdr which seems
> to support the E4000 on the Compro U680F. Could that driver be incorporated
> with the RTL83xxu from V4L-DVB?
>
> Regards,
> Marc
>

It is userspace driver, kernel drivers are little bit different. It is 
not possible to use as it is.

regards
Antti


-- 
http://palosaari.fi/
