Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:44023 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbaKPLlt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 06:41:49 -0500
Received: from [192.168.1.22] (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 79D38981E2
	for <linux-media@vger.kernel.org>; Sun, 16 Nov 2014 12:36:37 +0100 (CET)
Message-ID: <54688C45.1080507@southpole.se>
Date: Sun, 16 Nov 2014 12:36:37 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] rtl2832: implement PIP mode
References: <1415766190-24482-1-git-send-email-crope@iki.fi>	<1415766190-24482-3-git-send-email-crope@iki.fi>	<20141114173440.427324a8@recife.lan>	<54669210.1070101@iki.fi> <20141116082518.2144d9af@recife.lan>
In-Reply-To: <20141116082518.2144d9af@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/16/2014 11:25 AM, Mauro Carvalho Chehab wrote:
>
> [...]
> What demod(s) are exposed to userspace? both or just demod#1?
>
> If both are exposed, how userspace knows that demod#0 should not be
> used?
>
> Regards,
> Mauro
>

Currently both demods are exposed to userspace. While it is nice to have 
both I suggest that if a NM8847x demod is activated only expose that 
demod. That would remove the hack in master and would make it possible 
to faster move the NM8847x demods out of staging. The main reason for 
this hardware is the DVB-C and DVB-T2 support. Lets focus on getting 
that in an easy obtainable way.

MvH
Benjamin Larsson
