Return-path: <mchehab@pedra>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29026 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1AGAD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 19:03:59 -0500
Message-ID: <4D26586E.3080500@codeaurora.org>
Date: Thu, 06 Jan 2011 16:03:58 -0800
From: Yupeng Yan <yyan@codeaurora.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Markus Rechberger <mrechberger@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Haibo Zhong <hzhong@codeaurora.org>,
	Shuzhen Wang <shuzhenw@codeaurora.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <AANLkTinxG7_3cwwHBfjfsC9pQXn1fN6kXd0sAAxMD4GQ@mail.gmail.com> <1EEF208DFEB6C846A382BB12BB9CD5EC723263EFBB@NASANEXMB14.na.qualcomm.com> <201101050115.57699.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201101050115.57699.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for the comments - certainly good arguments to our lawyers :-)... 
actually the information of how to config the ISP HW is requested to be 
protected for now, we are working on certain degree of openness.

The HW config code is just a small part of the user space (daemon) 
tasks, the user space code also processes ISP states, carries out 3A 
algorithm and perform post processing features, etc. which will have to 
be protected, this is the reason why the daemon is used in QC solution.


On 1/4/2011 4:15 PM, Laurent Pinchart wrote:
> Hi,
>
> On Tuesday 04 January 2011 20:37:31 Yan, Yupeng wrote:
>> We will exploring the usage of libv4l2...however we still have the
>> difficulties to open-source hardware: our ISP and sensors, will need help
>> on how to address such issues.
> I suppose you mean open-sourcing hardware driver. There's no requirement to
> open-source the hardware at this point, although I would love to see that
> happening :-)
>
> Let's start with sensors, it's the easiest. Sensor drivers must not depend on
> the ISP driver, and the ISP driver must not depend on sensor drivers. They
> communicate together through the media controller and the V4L2 subdev APIs.
>
> You will obviously need to test your ISP driver with at least one sensor, but
> you're not required to submit the sensor driver along with the ISP driver
> (although it would be nice if you did so).
>
> Correct me if I'm wrong, but I don't think Qualcomm produces video sensors, so
> no Qualcomm confidential information would be disclosed in a sensor driver. If
> the sensor manufacturer hasn't released a sensor driver, or sensor
> specifications covered by a license that allows a GPL driver to be written,
> you will need to sort it out with the manufacturer. Note that public
> documentation is not strictly required to release an open-source driver (see
> the SMIA++ driver written by Nokia for instance), but that would be
> appreciated.
>
> For the ISP the problem is not that complex either. From what I understand
> Qualcomm is scared that publishing an open-source driver will backfire. I can
> see several reasons (I should probably say myths instead of reasons) for that
> fear:
>
> - "Competitors will steal my code". They can't. The code is highly hardware
> specific and doesn't contain much added value. It can't be reused as such.
> Even if code could be reused, it couldn't be "stolen" as it will be covered by
> the GPLv2.
>
> - "Competitors will get key information about my hardware". You need to ask
> yourself what you consider as key information. The fact that the output width
> is stored in register 0x12345678 is hardly key information (if it is, there's
> a more basic issue). The way statistics are computed might be. Based on my
> experience with ISPs key information isn't disclosed by the driver. The
> hardware algorithms (such as color conversion, faulty pixels correction,
> statistics gathering, ...) implementation are usually not disclosed by the
> code.
>
> - "Competitors will sue me for patent infringement". This goes along with the
> previous point. Patented ISP features are usually the ones you consider as key
> information, and details are thus not disclosed by the driver. Note that I
> don't care here about trivial patents with broad claims such as "a system to
> capture an image to memory". Even without any open-source driver infringement
> can still easily be proven (and the patent can easily be invalidated, although
> that costs money - Qualcomm should join the Open Invention Network :-)).
>
> None of those reasons are valid compared to the benefits you get from an open-
> source Linux driver.
>

