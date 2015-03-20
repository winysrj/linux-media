Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:47369 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbbCTXOE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 19:14:04 -0400
Message-ID: <550CA9B4.4050903@southpole.se>
Date: Sat, 21 Mar 2015 00:13:56 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] mn88473: implement lock for all delivery systems
References: <1426714629-15640-1-git-send-email-benjamin@southpole.se> <550AE0CC.5050407@iki.fi>
In-Reply-To: <550AE0CC.5050407@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2015 03:44 PM, Antti Palosaari wrote:
> Bad news. It does lock for DVB-C now, but DVB-T nor DVB-T2 does not lock.
>
> regards
> Antti

I'm getting tired :/. Had the time to test now and the checks is 
supposed to be negated.

if (utmp & 0xA0) { -> if (!(utmp & 0xA0))

But as stock dvbv5-scan crashes on ubuntu 14.04 and I can't unload the 
mn88473 module I will confirm this when I have an actual working version 
of dvbv5-scan and Ubuntu.

MvH
Benjamin Larsson
