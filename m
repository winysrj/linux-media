Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60189 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab2ARMuC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 07:50:02 -0500
Received: by wibhm6 with SMTP id hm6so2161783wib.19
        for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 04:50:01 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [RFC] dib8000: return an error if the TMCC is not locked
Date: Wed, 18 Jan 2012 13:49:57 +0100
References: <1326825928-29894-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326825928-29894-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201181349.57722.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 17 January 2012 19:45:28 you wrote:
> On ISDB-T, a few carriers are reserved for TMCC decoding
> (1 to 20 carriers, depending on the mode). Those carriers
> use the DBPSK modulation, and contain the information about
> each of the three layers of carriers (modulation, partial
> reception, inner code, interleaving, and number of segments).
> 
> If the TMCC carrier was not locked and decoded, no information
> would be provided by get_frontend(). So, instead of returning
> false values, return -EAGAIN.
> 
> Another alternative for this patch would be to add a flag to
> fe_status (FE_HAS_GET_FRONTEND?), to indicate that the ISDB-T
> TMCC carriers (and DVB-T TPS?), required for get_frontend
> to work, are locked.
> 
> Comments?

I think it changes the behaviour of get_frontend too much and in fact 
transmission parameter signaling (TPS for DVB-T, TMCC for ISDB-T) locks 
are already or should be if not integrated to the status locks.

Also those parameters can change over time and signal a 
"reconfiguration" of the transmission.

So, for me I would vote against this kind of implementation in favor a 
better one. Unfortunately I don't have a much better idea at hand right 
now.

--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
