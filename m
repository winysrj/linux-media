Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46109 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2E1N3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 09:29:42 -0400
Date: Mon, 28 May 2012 15:29:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] Add a keymap for FireDTV board
Message-ID: <20120528152937.75049a69@stein>
In-Reply-To: <1338210875-4620-1-git-send-email-mchehab@redhat.com>
References: <1338210875-4620-1-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On May 28 Mauro Carvalho Chehab wrote:
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -158,6 +158,7 @@ void rc_map_init(void);
>  #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
>  #define RC_MAP_WINFAST                   "rc-winfast"
>  #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
> +#define RC_MAP_FIREDTV			 "rc-firedtv"
>  
>  /*
>   * Please, do not just append newer Remote Controller names at the end.

The comment says that names should be inserted in alphabetical order. :-)
-- 
Stefan Richter
-=====-===-- -=-= ===--
http://arcgraph.de/sr/
