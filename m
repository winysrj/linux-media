Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57987 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab2GEPFo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jul 2012 11:05:44 -0400
Message-ID: <4FF5AD40.3070707@iki.fi>
Date: Thu, 05 Jul 2012 18:05:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 3/3] [media] tuner, xc2028: add support for get_afc()
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com> <1341497792-6066-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1341497792-6066-3-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/2012 05:16 PM, Mauro Carvalho Chehab wrote:
> Implement API support to return AFC frequency shift, as this device
> supports it. The only other driver that implements it is tda9887,
> and the frequency there is reported in Hz. So, use Hz also for this
> tuner.

What is AFC and why it is needed?


> +
> +		if (frq_lock)
> +			break;
> +		msleep(6);

6 ms is too small value for msleep(). you should use usleep_range() instead.


regards
Antti

-- 
http://palosaari.fi/


