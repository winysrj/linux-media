Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50109 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337Ab1FQPac (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 11:30:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron) mt9p031 sensor.
Date: Fri, 17 Jun 2011 17:30:46 +0200
Cc: Koen Kooi <koen@beagleboard.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	beagleboard@googlegroups.com, linux-media@vger.kernel.org,
	carlighting@yahoo.co.nz, mch_kot@yahoo.com.cn
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <BANLkTinqZ5xbTG=h+64rxVui=kXjjtehig@mail.gmail.com> <BANLkTimS=7a2arnrSXtsvoS46nFwaEH1Vg@mail.gmail.com>
In-Reply-To: <BANLkTimS=7a2arnrSXtsvoS46nFwaEH1Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171730.46536.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Friday 17 June 2011 17:26:26 javier Martin wrote:
> Laurent,
> have you been able to successfully test the driver?
> 
> I've found some issues and I don't know whether I should send a new version
> or just wait for you to mainline the last one and send a patch later.

Sorry for the late reply. I've briefly tested the driver but haven't been able 
to work on it. Please send a new version if you have one (with a description 
of the changes since the previous version). I'll then test that and push it to 
mainline through my tree (with a couple of changes if needed, I'll ask for 
your ack before pushing the driver).

-- 
Regards,

Laurent Pinchart
