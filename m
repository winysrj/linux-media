Return-path: <mchehab@localhost>
Received: from cantor2.suse.de ([195.135.220.15]:39357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965064Ab1GMIw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 04:52:27 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
Date: Wed, 13 Jul 2011 10:55:02 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <20110711174811.3c383595@tom-ThinkPad-T410> <201107131038.33153.laurent.pinchart@ideasonboard.com> <CACVXFVPs20+0ZFcrJpwDt+6jaaniYc9ZgSaKpkCyVAcGM+ZQmA@mail.gmail.com>
In-Reply-To: <CACVXFVPs20+0ZFcrJpwDt+6jaaniYc9ZgSaKpkCyVAcGM+ZQmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107131055.02557.oneukum@suse.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Am Mittwoch, 13. Juli 2011, 10:51:11 schrieb Ming Lei:
> Hi,
> 
> On Wed, Jul 13, 2011 at 4:38 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> 
> > They can still work, but not optimally, as they will be reset instead of
> > suspended/resumed. That's not acceptable.
> 
> If the "reset" you mentioned is usb bus reset signal, I think unbind&bind
> will not produce the reset signal.

You are correct. It will not.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
