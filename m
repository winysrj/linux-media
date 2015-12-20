Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:36546 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbbLTJrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 04:47:48 -0500
Subject: Re: [PATCH 3/3] rtl28xxu: change Astrometa DVB-T2 to always use
 hardware pid filters
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
 <1448763016-10527-3-git-send-email-benjamin@southpole.se>
 <5676224F.3030803@iki.fi>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <5676793B.1070209@southpole.se>
Date: Sun, 20 Dec 2015 10:47:39 +0100
MIME-Version: 1.0
In-Reply-To: <5676224F.3030803@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/20/2015 04:36 AM, Antti Palosaari wrote:
> Moikka!
> I did some testing and I cannot see reason to force hw pid filter for
> that device. I assume you somehow think it does not work without
> filtering, but I think it does.
>

[... proof that I was wrong ...]

>
> So point me the reason hw PID filters need to be forced.

The only reason would be that I suspected that high rates would not be 
possible over the bridge and that this was the default mode for the 
binary driver but as you proved that the bridge is able to support the 
rate this patch can be nacked.

>
> regards
> Antti

MvH
Benjamin Larsson
