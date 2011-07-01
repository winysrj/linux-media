Return-path: <mchehab@pedra>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57577 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757255Ab1GAQlq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 12:41:46 -0400
Message-ID: <4E0DF8C1.3090109@free.fr>
Date: Fri, 01 Jul 2011 18:41:37 +0200
From: Robert Jarzmik <robert.jarzmik@free.fr>
Reply-To: robert.jarzmik@free.fr
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fix suspend/resume of pxa_camera driver
References: <1217113647-20638-1-git-send-email-robert.jarzmik@free.fr> <Pine.LNX.4.64.0807270155020.29126@axis700.grange> <878wvnkd8n.fsf@free.fr> <Pine.LNX.4.64.0807271337270.1604@axis700.grange> <87tze997uu.fsf@free.fr> <Pine.LNX.4.64.0807291902200.17188@axis700.grange> <87iqun2ge3.fsf@free.fr> <Pine.LNX.4.64.0807310008190.26534@axis700.grange> <Pine.LNX.4.64.1106281515030.30771@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1106281515030.30771@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/28/2011 03:47 PM, Guennadi Liakhovetski wrote:
> Hi Robert
>
> Hope you don't mind me resuming an almost 3 year old mail thread;) I'm
> referring to your patches to soc-camera core and pxa-camera, adding PM
> support to them. Below is your message again, explaining, why the standard
> pm hooks cannot be used to suspend and resume the camera host and the
> camera sensor. While trying to make soc-camera play nicer with the V4L2
> generic framework, I was trying to eliminate as many redundant pieces from
> soc-camera as possible and replace them with standard methods. This made
> me re-consider those your patches. Let's have a look at your
> argumentation:
>
> So, we currently have 3 instances: soc-camera bus, i2c bus, and pxa-camera
> platform device driver. You say, i2c resumes as first, then at some point
> pxa-camera and soc-camera - in this or reverse order. This is why we
> cannoe use i2c-resume to bring the sensor up before pxa-camera has
> restored its master clock. So, currently we hook onto the soc-camera bus,
> which then calls pxa-camera's resume, which then restores camera host's
> state and resumes the sensor. Now, the question: wouldn't this also work,
> if we eliminate the soc-camera resume path? And instead just used
> pxa-camera resume method to bring up the sensor? Coule you please test the
> below patch?

Tested and working, the resume works OK, which means your thinking is 
good :)

Cheers.

--
Robert
