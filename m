Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56491 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2FCOnK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jun 2012 10:43:10 -0400
Message-ID: <4FCB77FB.50804@iki.fi>
Date: Sun, 03 Jun 2012 17:43:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Fwd: [Bug 827538] DVB USB device firmware requested in module_init()
References: <bug-827538-199927-UDXT6TGYkq@bugzilla.redhat.com> <4FC91D64.6090305@iki.fi> <4FCA41D7.2060206@iki.fi> <4FCACF9C.8060509@iki.fi> <4FCB76D3.7090800@interlinx.bc.ca>
In-Reply-To: <4FCB76D3.7090800@interlinx.bc.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2012 05:38 PM, Brian J. Murrell wrote:
> On 12-06-02 10:44 PM, Antti Palosaari wrote:
>>
>> That solves DVB USB firmware loading problems.
>
> As in you have a patch that works or it's just solved "in theory".  If
> you have a patch I'd love to apply it here and get this machine
> suspendable again.

I have patch which works but is as a proof-of-concept stage. I am just 
finalizing it. I will inform when it is ready, likely later tonight (as 
I would like to really see it fixes that suspend/resume problem as I am 
not able to reproduce it for some reason).

regards
Antit
-- 
http://palosaari.fi/
