Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53786 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673AbaJIM5n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Oct 2014 08:57:43 -0400
Message-ID: <54368641.5090404@collabora.com>
Date: Thu, 09 Oct 2014 08:57:37 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	'Kiran AVND' <avnd.kiran@samsung.com>,
	linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	laurent.pinchart@ideasonboard.com
CC: wuchengli@chromium.org, posciak@chromium.org, arun.m@samsung.com,
	ihf@chromium.org, prathyush.k@samsung.com, arun.kk@samsung.com,
	kiran@chromium.org, Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v2 14/14] [media] s5p-mfc: Don't change the image size
 to smaller than the request.
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com> <1411707142-4881-15-git-send-email-avnd.kiran@samsung.com> <11f301cfe2e2$0cacc810$26065830$%debski@samsung.com> <54354B8D.8050208@collabora.com> <125301cfe3a8$acd561f0$068025d0$%debski@samsung.com>
In-Reply-To: <125301cfe3a8$acd561f0$068025d0$%debski@samsung.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-10-09 06:06, Kamil Debski a écrit :
> I think the documentation does not specify how TRY_FMT/S_FMT should adjust
> the parameters. Maybe it would a good idea to add some flagS that determine
> the behaviour?
A flag could be a good option, maybe we should take a minute and discuss 
this next week.

cheers,
Nicolas
