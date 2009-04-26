Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41618 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZDZPfk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 11:35:40 -0400
Message-ID: <49F47F25.9090507@s5r6.in-berlin.de>
Date: Sun, 26 Apr 2009 17:35:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: mchehab@infradead.org
CC: Tobias Klauser <tklauser@distanz.ch>, linux-media@vger.kernel.org
Subject: Re: [PATCH] firedtv: Storage class should be before const qualifier
References: <1240751009-10023-1-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1240751009-10023-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tobias Klauser wrote:
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/media/dvb/firewire/firedtv-rc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
[...]

-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
