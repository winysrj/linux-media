Return-path: <mchehab@gaivota>
Received: from smtp-roam2.Stanford.EDU ([171.67.219.89]:42892 "EHLO
	smtp-roam.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745Ab0KBTfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 15:35:03 -0400
Message-ID: <4CD067E0.6070405@stanford.edu>
Date: Tue, 02 Nov 2010 12:34:56 -0700
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: New media framework user space usage
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>	<AANLkTi=83sd2yTsHt166_63vorioD5Fas32P9XLX15ss@mail.gmail.com>	<AANLkTin9M0FZrBYy5xq_-uCFbYa=LfZqLWurb_rB+uW_@mail.gmail.com>	<201011012302.03284.laurent.pinchart@ideasonboard.com> <AANLkTinWo7siGdbmRPNEfOfJHTZLEqxMFHOO9aqijP0d@mail.gmail.com>
In-Reply-To: <AANLkTinWo7siGdbmRPNEfOfJHTZLEqxMFHOO9aqijP0d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 11/2/2010 3:31 AM, Bastian Hecht wrote:
> Hello Laurent,
>
>>> I am the first guy needing a 12 bit-bus?
>> Yes you are :-) You will need to implement 12 bit support in the ISP driver,
>> or start by hacking the sensor driver to report a 10 bit format (2 bits will
>> be lost but you should still be able to capture an image).
> Isn't that an "officially" supported procedure to drop the least
> significant bits?
> You gave me the isp configuration
> .bus = { .parallel = {
>                         .data_lane_shift        = 1,
> ...
> that instructs the isp to use 10 of the 12 bits.
>

I suspect what Laurent means is that there's no way to send out 12-bit 
raw data to memory without ISP code changes. You can connect up a 12-bit 
sensor and just decimate to 10 bits, but that's not the same as the ISP 
driver supporting the 12-bit data paths that are possible in hardware.

That is, the OMAP3 ISP _is_ capable of writing out raw data to memory 
that's 12 bits per pixel, but the current ISP code hardcodes the data 
lane shift value in the ISP configuration, instead of making it depend 
on format - you'd want GRBG12 to set the data lane shift to 0, and 
GRBG10 or UYVY  (enum names approximate) to set the data lane shift to 
1.  We had a hack deep in the ISP code for a bit that did this, but it 
was hardcoded for the MT9P031, and we abandoned the idea pretty quickly.


Eino-Ville Talvala
Stanford University

