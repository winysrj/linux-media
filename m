Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45327 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1ADIel (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 03:34:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Shuzhen Wang" <shuzhenw@codeaurora.org>
Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
Date: Tue, 4 Jan 2011 09:35:17 +0100
Cc: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	hzhong@codeaurora.org, "Yan, Yupeng" <yyan@quicinc.com>
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <201012282123.58775.laurent.pinchart@ideasonboard.com> <000001cbabb8$49892d10$dc9b8730$@org>
In-Reply-To: <000001cbabb8$49892d10$dc9b8730$@org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101040935.17510.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Shuzhen,

On Tuesday 04 January 2011 03:37:10 Shuzhen Wang wrote:
> On Tuesday, December 28, 2010 12:24 PM Laurent Pinchart wrote:
> > 
> > I will strongly NAK any implementation that requires a daemon.
> 
> We understand the motivation behind making the daemon optional.
> However there are restrictions from legal perspective, which we
> don't know how to get around.
> 
> A simplest video streaming data flow with MSM ISP is like this:
> 
> Sensor -> ISP Hardware pipeline -> videobuf
> 
> The procedure to set up ISP pipeline is proprietary and cannot
> be open sourced. Without proper pipeline configuration, streaming
> won't work. And That's why we require the daemon.

Then I'm afraid you simply won't be able to provide an open-source Linux 
driver.

The purpose of a driver is to allow the system to access the hardware. Whether 
the code lives in the Linux kernel or in userspace is irrelevant here. If part 
of your driver is closed source, then it can't be called open-source and it 
can't be included in the mainline Linux kernel (there's a precedent on the 
same issue in the Direct Rendering Manager subsystem, open-source kernel code 
has been refused because it depended on closed-source userspace components).

If you want your hardware supported in the mainline Linux kernel you have to 
play by the rules and provide a complete open-source driver. You need to sort 
it out with your legal department and get a green light on disclosing 
information on how to setup the ISP pipeline.

-- 
Regards,

Laurent Pinchart
