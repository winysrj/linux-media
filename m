Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35511 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941AbZCKOHk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 10:07:40 -0400
Message-ID: <49B7C5A9.1050906@iki.fi>
Date: Wed, 11 Mar 2009 16:07:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: bloehei <bloehei@yahoo.de>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: EC168 support?!
References: <200903111217.17846.bloehei@yahoo.de> <49B7A1DF.1080204@iki.fi> <200903111424.02606.bloehei@yahoo.de>
In-Reply-To: <200903111424.02606.bloehei@yahoo.de>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bloehei wrote:
>> 40 00 00 00 40 08 c5 03 >>> 12 0c 93 80 06 12 0d 43 74 83 f0 e5 48 30 e3 78
hmm, at least that last fw upload packet is wrong. It should look like
40 00 00 00 00 18 c5 03 >>> 49 9f f5

I did yesterday many changes and fixed one bad bug that could be behind 
that. Please test with latest tree at:
http://linuxtv.org/hg/~anttip/ec168/

regards
Antti
-- 
http://palosaari.fi/
