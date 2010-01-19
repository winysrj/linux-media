Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46851 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0ASM4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 07:56:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [ANNOUNCE] git tree repositories
Date: Tue, 19 Jan 2010 13:56:48 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Douglas Landgraf <dougsland@gmail.com>
References: <4B55445A.10300@infradead.org>
In-Reply-To: <4B55445A.10300@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001191356.48403.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've started playing with the linuxtv git repositories. I've cloned v4l-
dvb.git into git://linuxtv.org/pinchartl/uvcvideo.git using git-menu and now 
have trouble pushing changes:

$ git push -v uvcvideo
Pushing to git://linuxtv.org/pinchartl/uvcvideo.git
fatal: The remote end hung up unexpectedly

What URL should I use to push changes ? 

-- 
Regards,

Laurent Pinchart
