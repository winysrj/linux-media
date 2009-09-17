Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58349 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZIQGj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Sep 2009 02:39:26 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Vladimir Pantelic <pan@nt.tu-darmstadt.de>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 17 Sep 2009 12:09:21 +0530
Subject: RE: V4L - Support for video timings at the input/output interface
Message-ID: <19F8576C6E063C45BE387C64729E73940436BA5C3D@dbde02.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
	<4AAF5056.8000001@nt.tu-darmstadt.de>
 <A69FA2915331DC488A831521EAE36FE4015515707E@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015515707E@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: davinci-linux-open-source-bounces@linux.davincidsp.com
> [mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On
> Behalf Of Karicheri, Muralidharan
> Sent: Thursday, September 17, 2009 2:39 AM
> To: Vladimir Pantelic
> Cc: davinci-linux-open-source@linux.davincidsp.com; Linux Media
> Mailing List
> Subject: RE: V4L - Support for video timings at the input/output
> interface
> 
> Hi,
> 
> >>
> >> 6. HDMI requires additional investigation. HDMI defines a whole
> bunch of
> >>     infoframe fields. Most of these can probably be exported as
> >controls?? Is
> >>     HDMI audio handled by alsa?
> >
> >7. how does this interface/co-exist with something like DSS2 on the
> omap3?
> >
> >who will "own" e.g. HDMI setup, DSS2 or V4L2?
> >
> 
> I still don't know what DSS2 is capable of doing. Will DSS2 work
> with
> v4l2 sub devices? If so, this RFC applies. I think DSS2 uses its own
> interface to integrate a encoder device. Besides it uses (I believe)
> sysfs
> to change the standards at the output. So I don't have an answer to
> your
> question. I will let DSS2 owner to respond.
> 
[Hiremath, Vaibhav] Let me clarify some points here - 

DSS2 is nothing but a simple underneath library which allows DSS hardware access for driver layer (V4L2 and Fbdev). So irrespective of whether DSS2 fits into sub-device model I think digital video timing RFC should fit in. 

I do agree that, once media controller will come in, we will have to update DSS2 accordingly. As you might be aware of the fact that, Tomi (from Nokia) owns DSS2, I will have initiate discussion with Tomi on this.


Thanks,
Vaibhav
> Murali
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-
> source
