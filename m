Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1379 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaDPRel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 13:34:41 -0400
Message-ID: <534EBF26.7080203@xs4all.nl>
Date: Wed, 16 Apr 2014 19:34:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Cookson <it@sca-uk.com>, Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl> <534EB9BE.60102@sca-uk.com>
In-Reply-To: <534EB9BE.60102@sca-uk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2014 07:11 PM, Steve Cookson wrote:
> Hi Guys,
> 
> On 14/04/14 15:02, Hans Verkuil wrote:
> 
>  > I'd appreciate it if you can test this with a proper video feed.
> 
> Ok, here is the first issue:
> 
> 1) I have a 640x480 video feed which displays appropriately through 
> stk1160, but only displays at 320x240 in ImpactVCBe.
> 
> In fact this is the same issue I had last year with:
> 
> echo cx23885 card=5 | sudo tee -a /etc/modules
> 
> Is your card giving you 640x480?

For no good reason AFAICT the initial resolution is set to 320x240. But
you can just set it to 640x480 (or more likely, 720x480 for NTSC or
720x576 for PAL):

v4l2-ctl -v width=640,height=480

Regards,

	Hans
