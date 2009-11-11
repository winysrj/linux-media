Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-88-194-224-77.ipcom.comunitel.net ([77.224.194.88]:38729
	"EHLO panicking.kicks-ass.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbZKKKbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 05:31:32 -0500
Message-ID: <4AFA918F.10708@panicking.kicks-ass.org>
Date: Wed, 11 Nov 2009 11:27:27 +0100
From: Michael Trimarchi <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: ov538-ov7690
References: <4AF89498.3000103@panicking.kicks-ass.org>	<4AF93DE5.6060901@panicking.kicks-ass.org>	<20091110081000.9e7c7717.rdunlap@xenotime.net>	<4AF99A03.7070303@panicking.kicks-ass.org>	<20091110090910.18f32748.rdunlap@xenotime.net> <20091110165747.35d31687@pedra.chehab.org>
In-Reply-To: <20091110165747.35d31687@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Em Tue, 10 Nov 2009 09:09:10 -0800
> Randy Dunlap <rdunlap@xenotime.net> escreveu:
> 
>>>> (**) This is also one of several codes that different kinds of host
>>>> controller use to indicate a transfer has failed because of device
>>>> disconnect.  In the interval before the hub driver starts disconnect
>>>> processing, devices may receive such fault reports for every request.
>>>>
>>>>
>>>>> Ok, this is not a big issue because I can use vlc to test the camera. But anybody
>>>>> knows why camorama, camstream, cheese crash during test. is it driver depend? or not?
>>>> Could be driver.  Easily could be a device problem too.
>>> I think that it can be a vl2 vl1 problem. Because now I can manage in skype too using
>>> the v4l1-compat library. Maybe my 2.6.32-rc5 is too new :(
>> I don't even know what vl2 vl1 means. ;)
> 
> He is probably referring to V4L1 x V4L2 API calls. Very unlikely. What libv4l

Yes

> does is to convert userspace calls via V4L1 to a V4L2 call to kernel. So,
> you're basically using the same API to communicate to userspace.

Ugly but very usefull in such application like skype, and people want it :(

> 
> It should be noticed that, if you're not using libv4l for the other
> applications, then you may be using a different format at the driver, since
> libv4l has the capability of doing format conversions.
> 
> So, it could be possible that the device firmware for some formats are broken.
> 
> Another possibility is that maybe libv4l is just discarding such errors.
> 
> Or, as Randy mentioned, it can be just a cable or a connector with bad contact.

Change the connector fix the packet problem. So at least the version ov538-ov7690
seems ok.

Thanks
