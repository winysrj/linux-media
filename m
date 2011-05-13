Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:19307 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab1EMW6b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 18:58:31 -0400
Message-ID: <4DCDB846.1010204@iki.fi>
Date: Sat, 14 May 2011 02:01:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hansverk@cisco.com>, Rob Clark <rob@ti.com>
Subject: Re: [ANNOUNCE] New OMAP4 V4L2 Camera Project started
References: <BANLkTi=RVE0zk83K0hn89H3S6CKEmKSj2A@mail.gmail.com>
In-Reply-To: <BANLkTi=RVE0zk83K0hn89H3S6CKEmKSj2A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Aguirre, Sergio wrote:
> Hi all,

Hi, Sergio!

> Just to let you know that I've just officially registered for a new
> project in the Pandaboard.org portal for OMAP4 v4l2 camera support.
> 
> You can find it here:
> 
> http://omiio.org/content/omap4-v4l2-camera
> 
> And also, you can find the actual Gitorious project with the code here:
> 
> https://www.gitorious.org/omap4-v4l2-camera
> 
> If anyone is interested in contributing for this project, please let
> me know, so I can add you as a contributor to the project.

I'm very, very happy to see a project to start implementing V4L2 support
for the OMAP 4 ISS!! Thanks, Sergio!

A few comments:


- The driver is using videobuf. I wonder if the driver would benefit
more from videobuf2.


- As far as I understand, the OMAP 4 ISS is partially similar to the
OMAP 3 one in design --- it has a hardware pipeline, that is. Fitting
the bus receivers and the ISP under an Media controller graph looks
relatively straightforward. The same might apply to SIMCOP, but then the
question is: what kind of interface should the SIMCOP have?

Being familiar with the history of the OMAP 3 ISP driver, I know this is
not a small project. Still, starting to use the Media controller in an
early phase would benefit the project in long run since the conversion
can be avoided later.


Which parts of the ISS require regular attention from the M3s? Is it the
whole ISS or just the SIMCOP, for example?

Kind regards,
Sakari Ailus

Ps. I have nothing against SoC camera, but when I look at the ISS
overview diagram (section 8.1 in my TRM) I can't avoid thinking that
this is exactly what the Media controller was created for. :-)

-- 
Sakari Ailus
sakari.ailus@iki.fi
