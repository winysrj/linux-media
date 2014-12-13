Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:49861 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966450AbaLMLNp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:13:45 -0500
Message-ID: <548C1F68.7010703@southpole.se>
Date: Sat, 13 Dec 2014 12:13:44 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/4] mn88472: implement dvb-t signal lock
References: <1418429925-16342-1-git-send-email-benjamin@southpole.se> <548BB7EA.1050502@iki.fi>
In-Reply-To: <548BB7EA.1050502@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2014 04:52 AM, Antti Palosaari wrote:
> That breaks DVB-C lock check as old "utmp = 0x08" was set according to 
> DVB-C lock check, right?
>
> Antti

I have a dvb-c setup now. I will respin this patch with dvb-c support 
tested properly.

MvH
Benjamin Larsson
