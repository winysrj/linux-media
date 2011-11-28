Return-path: <linux-media-owner@vger.kernel.org>
Received: from h1954367.stratoserver.net ([85.214.253.27]:58010 "EHLO
	h1954367.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1K1RKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 12:10:41 -0500
From: Hendrik Sattler <post@hendrik-sattler.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Problem with linux-3.1.3
Date: Mon, 28 Nov 2011 18:10:38 +0100
Cc: linux-media@vger.kernel.org
References: <201111271404.02435.post@hendrik-sattler.de> <201111281137.53063.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111281137.53063.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281810.38715.post@hendrik-sattler.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Montag, 28. November 2011, 11:37:52 schrieb Laurent Pinchart:
> > uvcvideo: Failed to submit URB 0 (-28).
> > 
> > 
> > Same for using e.g. Google+ Hangouts which worked fine using v3.1.
> > 
> > Any ideas what might be wrong?
> 
> I'm tempted to blame
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-
> stable.git;a=commit;h=f0cc710a6dec5b808a6f13f1f8853c094fce5f12. Could you
> please try reverting that patch and see if it fixes your issue ?

That's it :-D
I reverted f0cc710a6dec5b808a6f13f1f8853c094fce5f12 on-top of v3.1.3 and now 
the webcam is working again.
Should this go to v3.1.4 and 3.2?

Thanks...

HS
