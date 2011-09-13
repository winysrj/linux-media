Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57580 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1IMI5w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 04:57:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH] uvcvideo: Fix crash when linking entities
Date: Tue, 13 Sep 2011 10:57:48 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Josh Boyer <jwboyer@redhat.com>, linux-media@vger.kernel.org,
	Dave Jones <davej@redhat.com>,
	Daniel Dickinson <libre@cshore.neomailbox.net>
References: <1315348148-7207-1-git-send-email-laurent.pinchart@ideasonboard.com> <201109121620.39982.laurent.pinchart@ideasonboard.com> <20110912172233.GB27651@elie>
In-Reply-To: <20110912172233.GB27651@elie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131057.49337.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

On Monday 12 September 2011 19:22:33 Jonathan Nieder wrote:
> Laurent Pinchart wrote:
> > I've just sent a pull request to Mauro.
> 
> Thanks!  Looks good to me, for what little that's worth.  My only nits
> are that in the future it might be nice to "Cc: stable" and credit
> testers so they can grep through commit logs to find out if the kernel
> is fixed.

I agree. Sorry for having forgotten about that.

Mauro, if it's not too late, can you add "Cc: stable@kernel.org" to this patch 
? Or should I send you a new pull request ?

-- 
Regards,

Laurent Pinchart
