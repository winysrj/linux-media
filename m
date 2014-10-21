Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41292 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbaJUMnS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 08:43:18 -0400
Message-ID: <544654DF.4000201@collabora.com>
Date: Tue, 21 Oct 2014 08:43:11 -0400
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
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
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com> <1411707142-4881-15-git-send-email-avnd.kiran@samsung.com> <11f301cfe2e2$0cacc810$26065830$%debski@samsung.com> <54354B8D.8050208@collabora.com> <125301cfe3a8$acd561f0$068025d0$%debski@samsung.com> <544644D9.4020701@xs4all.nl>
In-Reply-To: <544644D9.4020701@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-10-21 07:34, Hans Verkuil a écrit :
>
> I think we should add flags here as well. NEAREST (the default), 
> ROUND_DOWN and
> ROUND_UP. Existing calls will use NEAREST. I can think of use-cases 
> for all
> three of these, and I think the caller should just have to specify 
> what is
> needed.
>
> Just replacing the algorithm used seems asking for problems, you want 
> to be
> able to select what you want to do. 

One more thing, we realize that in selection scenario, we do want 
nearest or lowest, so indeed a flag that let user space choose is the best.

Nicolas

