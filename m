Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40345 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab2AJVqD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 16:46:03 -0500
Message-ID: <4F0CB197.5010306@iki.fi>
Date: Tue, 10 Jan 2012 23:45:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to
 one frontend
References: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/05/2012 05:37 PM, Mauro Carvalho Chehab wrote:
> With all these series applied, it is now possible to use frontend 0
> for all delivery systems. As the current tools don't support changing
> the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
> be used to change between them:
>
> For example, to use DVB-T with the standard scan:
>
> $ ./dvb-fe-tool -d DVBT&&  scan /usr/share/dvb/dvb-t/au-Adelaide
>
> [1] http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils

I tested that now using nanoStick T2 cxd2820r driver. I got it working 
somehow, but I suspect there is some bugs at least for DVB-C. But forget 
those as now.

As it now registers only one frontend I must switch mode using 
dvb-fe-tool when I want to use DVB-C. Argh.

I don't see reason why it was needed to remove old DVB-C frontend1. Why 
it wasn't possible to leave FE1 as it was and enhance only functionality 
of FE0 like it is now? For that strategy we doesn't break old set-ups as 
now happens.

regards
Antti


-- 
http://palosaari.fi/
