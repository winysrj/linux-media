Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:61894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab1BVPbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 10:31:02 -0500
Date: Tue, 22 Feb 2011 16:30:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	saaguirre@ti.com
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
In-Reply-To: <201102221617.55726.hansverk@cisco.com>
Message-ID: <Pine.LNX.4.64.1102221628570.1380@axis700.grange>
References: <cover.1298368924.git.svarbanov@mm-sol.com>
 <201102221432.50847.hansverk@cisco.com> <Pine.LNX.4.64.1102221456590.1380@axis700.grange>
 <201102221617.55726.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 22 Feb 2011, Hans Verkuil wrote:

> Secondly, if we rely on negotiations, then someone at some time might change 
> things and suddenly the negotiation gives different results which may not work 
> on some boards. And such bugs can be extremely hard to track down. So that is 

Sorry, there's always a chance, that someone breaks something. Always when 
changing central algorithms you have to take care, that behaviour doesn't 
change on existing configurations. Nothing new there.

> why I don't want to rely on negotiations of these settings. People are free to 
> copy and paste, though. I assume (and hope) that they will test before sending 
> a patch, so if it works with the copy-and-pasted settings, then that's good 
> enough for me.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
