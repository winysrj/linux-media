Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:49875 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZK0OZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 09:25:17 -0500
Message-ID: <4B0FDD66.9090903@crans.org>
Date: Fri, 27 Nov 2009 15:08:38 +0100
From: Brice Dubost <dubost@crans.org>
MIME-Version: 1.0
To: Benedict bdc091 <bdc091@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: how to get a registered adapter name
References: <746d58780909140842o8952bf1g8f7851eee9ec0093@mail.gmail.com>
In-Reply-To: <746d58780909140842o8952bf1g8f7851eee9ec0093@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Benedict bdc091 wrote:
> Hi list,
> 
> I'd like to enumerate connected DVB devices from my softawre, based on
> DVB API V3.
> Thank to ioctl FE_GET_INFO, I'm able to get frontends name, but they
> are not "clear" enough for users.
> 
> After a "quick look" in /var/log/messages I discovered that adapters
> name are much expressives:
> 
>> ...
>> DVB: registering new adapter (ASUS My Cinema U3000 Mini DVBT Tuner)
>> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
>> ...
> 
> So, I tried to figure out a way to get "ASUS My Cinema U3000 Mini DVBT
> Tuner" string from adapter, instead of "DiBcom 7000PC" from adapter's
> frontend...
> Unsuccefully so far.
> 
> Any suggestions?
> 

Hello,

I have the same issue, I look a bit to the code of the DVB drivers, it
seems not obvious to recover this name as it is written now

It is stored in the "struct dvb_adapter". and printed by
dvb_register_adapter, but doesn't seems to be available by other functions

I don't think changing the v3 API or adding a new IOCTL for this is a
good idea.

What about using the new DVB API (v5) to do this? Since I'm not an
expert with this API, is there some people familiar with it which can
give me advices about the good way to do it (and if it is a good idea)
so that I can start to write some code.

Thank you

Regards
