Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40081 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3FHLcc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jun 2013 07:32:32 -0400
Message-ID: <51B31628.2090702@iki.fi>
Date: Sat, 08 Jun 2013 14:31:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Rodrigo Tartajo <rtarty@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: rtl28xxu IR remote
References: <51B26B2C.7090406@gmail.com>
In-Reply-To: <51B26B2C.7090406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/2013 02:22 AM, Rodrigo Tartajo wrote:
> Hi, I just compiled and tested Antti Palosaari branch and can confirm the remote works for my RTL2832U. I have updated the wiki[1] entry with the steps necessary to configure the remote control. Please confirm if these fixes your problem.
>
> Rodrigo.
>
> [1] http://www.linuxtv.org/wiki/index.php/RealTek_RTL2832U


Good. I tested it quite limited set of remote controllers and even found 
one NEC remote which didn't worked - RC_MAP_MSI_DIGIVOX_II. Maybe 
timings should be adjusted or there is some other factor. I didn't cared 
to look it more as I am not very familiar with these raw remote 
protocols and real life variations.

I also had no reference to adjust remote timings. I just used one RC5 
remote and calibrated timings according to that. If there is someone 
having better reference signals, then feel free to change that timing 
value to more correct.


regards
Antti

-- 
http://palosaari.fi/
