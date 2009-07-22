Return-path: <linux-media-owner@vger.kernel.org>
Received: from eyemagnet.com ([202.160.117.202]:56147 "EHLO eyemagnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbZGVDrN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 23:47:13 -0400
Received: from [192.168.1.192] (unknown [64.81.73.170])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by eyemagnet.com (Postfix) with ESMTP id 9CEA68223
	for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 15:47:12 +1200 (NZST)
Message-ID: <4A668BB9.1020700@eyemagnet.com>
Date: Tue, 21 Jul 2009 20:47:05 -0700
From: Steve Castellotti <sc@eyemagnet.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: offering bounty for GPL'd dual em28xx support
References: <4A6666CC.7020008@eyemagnet.com>	 <829197380907211842p4c9886a3q96a8b50e58e63cbf@mail.gmail.com>	 <4A667735.40002@eyemagnet.com> <829197380907211932v6048d099h2ebb50da05959d89@mail.gmail.com>
In-Reply-To: <829197380907211932v6048d099h2ebb50da05959d89@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2009 07:32 PM, Devin Heitmueller wrote:
> I agree that *in theory* you should be able to do two devices.  A back
> of the envelope calculation of 640x480 at 30fps in YUVY capture should
> be about 148Mbps.  That said, I don't think the scenario you are
> describing has really been tested/debugged previously.  If I had to
> guess, my suspicion would be a bug in the driver code that calculates
> which USB alternate mode to operate in, which results in the driver
> reserving more bandwidth than necessary.
>
> I would have dig into the code and do some testing in order to have a
> better idea where the problem is.  Do you have a specific em28xx
> product in mind that you intend to use?
>

     Well in theory there's no difference between theory and practice, 
but in practice there is (c:


     More than happy to coordinate some testing of a variety of em28xx 
devices we have handy around the office if it would help isolate any 
bugs. We could throw some QA resource at the problem if nothing else.


     One of the devices we're supposed to be able to acquire in bulk is 
no-name brand that simply says "VC-211A" on the label. "lsusb" output 
looks like this:

ID eb1a:2861 eMPIA Technology, Inc.


     The other says "GrabBeeX+ deluxe" and has this identifier:


ID eb1a:2821 eMPIA Technology, Inc.


     We have a 2-3 others on hand as well.


     Once again, thanks for the responsiveness and please let me know 
what we can do to contribute.


Cheers

Steve


-- 

Steve Castellotti
sc@eyemagnet.com
Technical Director
Eyemagnet Limited
http://www.eyemagnet.com


