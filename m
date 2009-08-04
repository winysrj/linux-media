Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35196 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZHDUO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 16:14:56 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Magnus Damm <magnus.damm@gmail.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"eduardo.valentin@nokia.com" <eduardo.valentin@nokia.com>,
	"Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Tue, 4 Aug 2009 15:14:46 -0500
Subject: RE: Linux Plumbers Conference 2009: V4L2 API discussions
Message-ID: <A69FA2915331DC488A831521EAE36FE401451814F8@dlee06.ent.ti.com>
References: <200908040912.24718.hverkuil@xs4all.nl>
 <19F8576C6E063C45BE387C64729E73940432AF3A5D@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940432AF3A5D@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I plan to register for this. Following are some of the issues that I face today while porting TI DaVinci video drivers to open source:-

1) VPBE display drivers (DM6446,DM355 & DM365): Current implementation of display drivers uses encoder manager (encoders registers with this framework) and display manager (allocating video and OSD layers, managing the OSD hardware etc.). Both FBDev and V4l2 bridge drivers interfaces with these for display timing information and resource allocation. The encoders are developed using a encoder interface that are protocol independent vs sub devices framework in open source that are v4l2 specific. The protocol independent interface was used to avoid building v4l2 sub system when using FBDev devices (That driver VPBE). Internal driver uses SysFs interface to change output and standard at the active encoder (Same functionality is removed from v4l2 display device). I plan to discuss this with you in detail so that we could start working on the porting. I will also go through your RFC to find out if any thing is applicable related to this work

2) Previewer & Resizer driver. I am working with Vaibhav who had worked on an RFC for this. The previewer and resizer devices are doing memory to memory operations. Also should be flexible to use these hardware with capture driver to do on the fly preview and resize. The TI hardware is parameter intensive. We believe these parameters are to be exported to user space through IOCTLs and would require addition of new IOCTLs and extension of control IDs. We will be working with you on this as well.

3) Setting up timing information in capture and display sub devices (example for HD resolution capture and display) . I think Your media processor RFC discuss this.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: davinci-linux-open-source-bounces@linux.davincidsp.com
>[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>Of Hiremath, Vaibhav
>Sent: Tuesday, August 04, 2009 1:13 PM
>To: Hans Verkuil; linux-media@vger.kernel.org
>Cc: Magnus Damm; davinci-linux-open-source@linux.davincidsp.com; linux-
>omap@vger.kernel.org; eduardo.valentin@nokia.com; Dongsoo, Nathaniel Kim
>Subject: RE: Linux Plumbers Conference 2009: V4L2 API discussions
>
>
>
>> -----Original Message-----
>> From: davinci-linux-open-source-bounces@linux.davincidsp.com
>> [mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On
>> Behalf Of Hans Verkuil
>> Sent: Tuesday, August 04, 2009 12:42 PM
>> To: linux-media@vger.kernel.org
>> Cc: eduardo.valentin@nokia.com; davinci-linux-open-
>> source@linux.davincidsp.com; linux-omap@vger.kernel.org; Magnus
>> Damm; Dongsoo, Nathaniel Kim
>> Subject: Linux Plumbers Conference 2009: V4L2 API discussions
>>
>> Hi all,
>>
>> During this years Plumbers Conference I will be organizing a session
>> (or
>> possibly more than one) on what sort of new V4L2 APIs are needed to
>> support the new SoC devices. These new APIs should also solve the
>> problem
>> of how to find all the related alsa/fb/ir/dvb devices that a typical
>> video
>> device might create.
>>
>> A proposal was made about a year ago (note that this is a bit
>> outdated
>> by now, but the basics are still valid):
>>
>> http://www.archivum.info/video4linux-list%40redhat.com/2008-
>> 07/msg00371.html
>>
>> In the past year the v4l2 core has evolved enough so that we can
>> finally
>> start thinking about this for real.
>>
>> I would like to know who will be attending this conference. I also
>> urge
>> anyone who is working in this area and who wants to have a say in
>> this to
>> attend the conference. The goal is to prepare a new RFC with a
>> detailed
>> proposal on the new APIs that are needed to fully support all the
>> new
>> SoCs. So the more input we get, the better the end-result will be.
>>
>[Hiremath, Vaibhav] Hi Hans,
>
>I will be attending the conference and along with above mentioned RFC I
>would want to discuss some of the open issues, forthcoming TI devices,
>their complexity and required software interfaces (media processor (as you
>mentioned above)) and similar stuff.
>
>
>I will work with you offline before sharing the details here with the
>community.
>
>Thanks,
>Vaibhav Hiremath
>
>> Early-bird registration is still possible up to August 5th (that's
>> tomorrow :-) ).
>>
>> Regards,
>>
>> 	Hans
>>
>> --
>> Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>>
>> _______________________________________________
>> Davinci-linux-open-source mailing list
>> Davinci-linux-open-source@linux.davincidsp.com
>> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-
>> source
>_______________________________________________
>Davinci-linux-open-source mailing list
>Davinci-linux-open-source@linux.davincidsp.com
>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
