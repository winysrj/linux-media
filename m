Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.integra.fr ([217.115.161.167]:47155 "EHLO mta2.integra.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbZCDRXr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 12:23:47 -0500
Message-ID: <49AEB91C.6010804@gmail.com>
Date: Wed, 04 Mar 2009 18:23:40 +0100
From: Pierre Gronlier <ticapix@gmail.com>
MIME-Version: 1.0
To: lotway@nildram.co.uk
CC: linux-media@vger.kernel.org
Subject: Re: TT S2-3200 and CAMs
References: <49AE8BB3.3010501@nildram.co.uk>
In-Reply-To: <49AE8BB3.3010501@nildram.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lou Otway wrote:
> Hi,
> 
> I've been testing the TT S2-3200 card and while it performs well for FTA
> services I have been unable to get it working with encrypted services using
> the CI slot.
> 
> With VLC I am able to tune to the transponder and pick up all the services
> but they are not decrypted, unencrypted services work fine.
> 
> Using a DVB-S card with CI I am able to tune successfully, proving the CAMs
> are valid. This leads me to believe there may be a problem with the drivers
> for the S2-3200.
> 
> Has anyone managed to get CAMs working with this card?
> 

yes, I manage to decrypt a entire dvb-s transponder using a powercam and
mumudvb for streaming channels.

I'm using the v4l-dvb driver from the hg repository.

For mumudvb, I made a checkout of the git repository
http://mumudvbgit.braice.net/mumudvb.git and compiled the source with
LIBDVBEN50221=1 make (you need the dvb-apps to be installed)


But using this card, I didn't manage to lock on my second lnd head, so I
manage to lock on astra 19.2E but not on hotbird 13.0E.


Pierre

> Any advice gratefully recieved.
> 
> Many thanks,
> 
> Lou
> -- 
> Lou Otway
> mailto:lotway@nildram.co.uk
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

