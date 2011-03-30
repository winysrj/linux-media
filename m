Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:56027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1C3Hk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 03:40:58 -0400
Date: Wed, 30 Mar 2011 09:40:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paolo Santinelli <paolo.santinelli@unimore.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH/DRAFT 0/2] Add livecrop to soc-camera and to sh CEU
In-Reply-To: <AANLkTimuV6Mjvp5K+mUOOBgvRsw+vWtYqPb_Vqr8-tDo@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103300932050.4695@axis700.grange>
References: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
 <Pine.LNX.4.64.1103292357270.13285@axis700.grange>
 <AANLkTimhP_YoqKRKyPzRbM6gw5jXVNV2D3pveRqqH0W_@mail.gmail.com>
 <AANLkTimuV6Mjvp5K+mUOOBgvRsw+vWtYqPb_Vqr8-tDo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is just a dump of an idea, I've been toying with to support live zoom 
on soc-camera. I do not know, if we'll end up mainlining this, because the 
proper way to do this is to use MC / pad-level operations, and even if we 
do this, at least the second patch will have to be further split into 2 or 
three patches. So, this is mainly just for Paolo to have a look.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
