Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:49578
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZINOag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 10:30:36 -0400
Message-ID: <4AAE548E.1060905@wilsonet.com>
Date: Mon, 14 Sep 2009 10:34:54 -0400
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Brandon Jenkins <bcjenkins@tvwhere.com>
CC: Janne Grunau <j@jannau.net>, Andy Walls <awalls@radix.net>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
References: <200909011019.35798.jarod@redhat.com>	 <1251855051.3926.34.camel@palomino.walls.org>	 <de8cad4d0909131023t7103b446sf6b20889567556ee@mail.gmail.com>	 <6EBCDFA3-FAAA-4757-97B6-9CF3442FE920@wilsonet.com>	 <20090913221314.GA11178@aniel.lan> <4AAD9732.9060003@wilsonet.com> <de8cad4d0909140632g7e20d501p6ae3d68e5cd30c21@mail.gmail.com>
In-Reply-To: <de8cad4d0909140632g7e20d501p6ae3d68e5cd30c21@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/2009 09:32 AM, Brandon Jenkins wrote:
> Driver build procedure used:
>
> Cloned http://hg.jannau.net/hdpvr
> Pulled http://linuxtv.org/hg/v4l-dvb/
> Pulled http://linuxtv.org/hg/~awalls/v4l-dvb/
>
> This should bring in all changes for HDPVR and CX18.
>
> What specifically would you like me to test? I can't reload the
> modules until the kids are done watching TV. :)

Whatever it was you did last time that was triggering an oops... Things 
I did myself were hotplugging the hdpvr after everything else was 
already up, and booting with the hdpvr connected (which in my case, led 
to it being set up before any of the other cards).

-- 
Jarod Wilson
jarod@wilsonet.com
