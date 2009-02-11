Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:55430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZBKNBQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2009 08:01:16 -0500
Date: Wed, 11 Feb 2009 14:01:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] DAB: fix typo
In-Reply-To: <498622DA.9080106@freemail.hu>
Message-ID: <alpine.LNX.1.10.0902111400540.31014@jikos.suse.cz>
References: <498622DA.9080106@freemail.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-591855035-1234357275=:31014"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-591855035-1234357275=:31014
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Sun, 1 Feb 2009, Németh Márton wrote:

> From: Márton Németh <nm127@freemail.hu>
> 
> Fix typo in "DAB adapters" section in Kconfig.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> --- linux-2.6.29-rc3/drivers/media/Kconfig.orig	2008-12-25 00:26:37.000000000 +0100
> +++ linux-2.6.29-rc3/drivers/media/Kconfig	2009-02-01 13:30:54.000000000 +0100
> @@ -117,7 +117,7 @@ source "drivers/media/dvb/Kconfig"
>  config DAB
>  	boolean "DAB adapters"
>  	---help---
> -	  Allow selecting support for for Digital Audio Broadcasting (DAB)
> +	  Allow selecting support for Digital Audio Broadcasting (DAB)
>  	  Receiver adapters.

Didn't find this in today's linux-next, so I have applied it to trivial 
tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
--336216065-591855035-1234357275=:31014--
