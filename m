Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46810 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab1LIS0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 13:26:48 -0500
Message-ID: <4EE252E5.2050204@iki.fi>
Date: Fri, 09 Dec 2011 20:26:45 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1323454852-7426-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/09/2011 08:20 PM, Mauro Carvalho Chehab wrote:
> The DRX-K doesn't change the delivery system at set_properties,
> but do it at frontend init. This causes problems on programs like
> w_scan that, by default, opens both frontends.
>
> Instead, explicitly set the format when set_parameters callback is
> called.

May I ask why you don't use mfe_shared flag instead?

regards
Antti

-- 
http://palosaari.fi/
