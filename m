Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:57495 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbcENTLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2016 15:11:07 -0400
Subject: Re: [PATCH 1/3] rtl28xxu: increase failed I2C msg repeat count to 2
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <1463202876-18381-1-git-send-email-crope@iki.fi>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <573776B1.50309@southpole.se>
Date: Sat, 14 May 2016 21:04:17 +0200
MIME-Version: 1.0
In-Reply-To: <1463202876-18381-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2016 07:14 AM, Antti Palosaari wrote:
> 1 wasn't enough for mn88472 chip on Astrometa device, so increase
> it by one.
>

I did need more then 2 repeats some times (I don't have any logs to back 
it up right now), so can we add some more just in case or can it mess up 
something else ?

MvH
Benjamin Larsson
