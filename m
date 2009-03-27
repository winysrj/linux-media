Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43179 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbZC0AVG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 20:21:06 -0400
Message-ID: <49CC1BEA.20305@iki.fi>
Date: Fri, 27 Mar 2009 02:20:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: linux-dvb@linuxtv.org, vdr@linuxtv.org,
	v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [ADMIN] linuxtv.org is moving
References: <20090325162541.GB22582@linuxtv.org> <20090326185729.GA10352@linuxtv.org>
In-Reply-To: <20090326185729.GA10352@linuxtv.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Johannes Stezenbach wrote:
> On Wed, Mar 25, 2009 at 05:25:41PM +0100, Johannes Stezenbach wrote:
>> linuxtv.org will move to a new server machine tomorrow. Expect
>> some downtime during the move and please be patient. Everything
>> on the old machine will be rsynced to the new machine right before
>> the switch so nothing should get lost.
> 
> The move is done, but the DNS updates are not out there yet,
> so especially mail won't work yet until the caches are updated,
> but everything else should.
> 
> The new IP address is 217.160.6.122.

[crope@localhost v4l-dvb]$ hg push 
ssh://anttip@linuxtv.org/hg/~anttip/af9015
pushing to ssh://anttip@linuxtv.org/hg/~anttip/af9015
searching for changes
remote: abort: No space left on device
[crope@localhost v4l-dvb]$ host linuxtv.org
linuxtv.org has address 217.160.6.122

I removed 5-6 my old devel trees, still no space :o

regards
Antti
-- 
http://palosaari.fi/
