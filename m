Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:33901 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbaHAFOY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 01:14:24 -0400
Message-ID: <53DB20E4.7020803@unixsol.org>
Date: Fri, 01 Aug 2014 08:08:52 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: Bjoern <lkml@call-home.ch>, Ralph Metzler <rjkm@metzlerbros.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>
Subject: Re: ddbridge -- kernel 3.15.6
References: <53C920FB.1040501@grumpydevil.homelinux.org>	 <53CAAF9D.6000507@kaiser-linux.li>	 <1406697205.2591.13.camel@bjoern-W35xSTQ-370ST>	 <21465.62099.786583.416351@morden.metzler> <1406868897.2548.15.camel@bjoern-W35xSTQ-370ST>
In-Reply-To: <1406868897.2548.15.camel@bjoern-W35xSTQ-370ST>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/1/14 7:54 AM, Bjoern wrote:
> On Do, 2014-07-31 at 09:38 +0200, Ralph Metzler wrote:

>> It is not like drivers are not available and supported, just
>> not in the mainline kernel tree. 
> 
> Right... and I hope that can be changed. I really really like the DD
> hardware I have, but always having to rebuild everything with a new
> kernel is just not my idea of how hardware should run in 2014 on Linux
> anymore.

I have more than 30 ddbridge dvb-s devices and more than 30 dvb-c/t devices.

The fact that the drivers are not in the main tree is the biggest problem
with these devices. The hardware is great (never had a problem with it)
but having to install experimental media build is just stupid.

When I bought the devices I knew that the driver is not in the main tree
but I really hoped that this would change. Now 3 years later it is still
not the case. That's bullshit.

Come on Digital Devices, you have the drivers, please, pretty please, submit
them upstream, go through the merge process and make us - our clients a
happy bunch.

Like Bjoern said, it's 2014, you have the drivers, keeping them out
of main kernel and having your customers go through hoops to get them
working is not acceptable.

-- 
Georgi Chorbadzhiyski | http://georgi.unixsol.org/ | http://github.com/gfto/
