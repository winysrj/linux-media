Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:26827 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1HaONE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 10:13:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFC PATCH 5/6] V4L menu: move all platform drivers to the bottom of the menu.
Date: Wed, 31 Aug 2011 16:13:00 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl> <99c353d49539e4a2a8f165db612ed6a7e82a57b9.1314797675.git.hans.verkuil@cisco.com> <4E5E3C2B.6020703@infradead.org>
In-Reply-To: <4E5E3C2B.6020703@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311613.00238.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, August 31, 2011 15:50:35 Mauro Carvalho Chehab wrote:
> Em 31-08-2011 10:38, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> IMO, a submenu for those drivers makes sense.

I thought about that, but actually you never see any of these drivers
unless you have the right architecture options enabled.

So if you would put them in a submenu, then you'll end up with just a
few entries. It's not worth it in my opinion.

Regards,

	Hans
