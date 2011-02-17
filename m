Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:55061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1BQXUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 18:20:09 -0500
Date: Fri, 18 Feb 2011 00:20:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Anatolij Gustschin <agust@denx.de>
Subject: Re: soc-camera: vb2 continued: mx3_camera
In-Reply-To: <Pine.LNX.4.64.1102072238430.2023@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102180018520.1841@axis700.grange>
References: <Pine.LNX.4.64.1102041051030.14717@axis700.grange>
 <Pine.LNX.4.64.1102072238430.2023@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 7 Feb 2011, Guennadi Liakhovetski wrote:

> Hi
> 
> One more soc-camera host driver has been converted to videobuf2: 
> mx3_camera for i.MX3* SoCs. I also added Anatolij's patches to the branch. 
> Please, review / test. The branch is available at
> 
> git://linuxtv.org/gliakhovetski/v4l-dvb.git soc_camera-vb2

Two persons reported problems, when trying to directly clone the above 
tree. The following worked for me:

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
cd linux-2.6/
git remote add soc-camera git://linuxtv.org/gliakhovetski/v4l-dvb.git
git remote update
git checkout -b v4l-devel soc-camera/soc_camera-vb2

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
