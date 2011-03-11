Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:38457 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1CKDzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 22:55:17 -0500
Received: from epmmp1 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LHV003CXK848ZF0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 12:55:16 +0900 (KST)
Received: from DOJAERYULOH01 ([12.23.103.241])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LHV0041DK8425@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 12:55:16 +0900 (KST)
Date: Fri, 11 Mar 2011 12:55:11 +0900
From: Jaeryul Oh <jaeryul.oh@samsung.com>
Subject: RE: [PATCH/RFC 0/2] Support controls at the subdev file handler level
In-reply-to: <4D7929EC.7080003@gmail.com>
To: 'Sylwester Nawrocki' <snjw23@gmail.com>, jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Reply-to: jaeryul.oh@samsung.com
Message-id: <016101cbdfa0$219e6060$64db2120$%oh@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <000601cbdf09$76be8c10$643ba430$%park@samsung.com> <4D7929EC.7080003@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, 

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
> Sent: Friday, March 11, 2011 4:44 AM
> To: jtp.park@samsung.com
> Cc: linux-media@vger.kernel.org; laurent.pinchart@ideasonboard.com
> Subject: Re: [PATCH/RFC 0/2] Support controls at the subdev file handler
> level
> 
> Hi,
> 
> On 03/10/2011 10:56 AM, Jeongtae Park wrote:
> > Hi, all.
> >
> > Some hardware need to handle per-filehandle level controls.
> > Hans suggests add a v4l2_ctrl_handler struct v4l2_fh. It will be work
> fine.
> > Although below patch series are for subdev, but it's great start point.
> > I will try to make a patch.
> >
> > If v4l2 control framework can be handle per-filehandle controls,
> > a driver could be handle per-buffer level controls also. (with VB2
> callback
> > operation)
> >
> 
> Can you elaborate to what kind of per buffer controls are you referring to?
> Using optional meta data planes is expected to be a proper way to do such
> things. Either to pass meta data from application to driver or in the
> opposite
> direction.
> 
> I can't see how the per buffer controls can be dependent on a per file
> handle
> control support. Perhaps this is only specific to some selected devices.
> 

There might be some missing point about this issue. To support full feature of 
codec, hierarchy should be done as below

Per-node(decoder or encoder)
   |
   |---- Per-file for multi-instance
                     |
                     |--------Per-buffer control for setting dynamic configuration 

Some cases are using per-node handling is enough, but some cases are for per-file
And because of codec characteristics, we need to support per-buffer at this 
hierarchy as above. 
Let's talk more about this at Warsaw.


> --
> Regards,
> Sylwester Nawrocki
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

