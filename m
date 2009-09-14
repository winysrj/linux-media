Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:43404 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZINQaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 12:30:20 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1009766fge.1
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 09:30:22 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/3] Add driver for OmniVision OV9640 sensor
Date: Mon, 14 Sep 2009 18:29:55 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200908220850.07435.marek.vasut@gmail.com> <200909141635.24286.marek.vasut@gmail.com> <Pine.LNX.4.64.0909141643160.4359@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909141643160.4359@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909141829.55485.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne Po 14. září 2009 16:45:50 Guennadi Liakhovetski napsal(a):
> Ok, you were faster than I:-) If you agree, I can just remove those two
> RGB formats myself, changing your comment to a TODO,

We can #ifdef them so others dont have to re-add them by hand if they want to 
try fixing those.

> and modify the
> comment next to msleep(150)

140 didn't

> (if you could tell me what value didn't work,
> that would be appreciated) and push it out.
> 
> Thanks
> Guennadi

Cheers
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
