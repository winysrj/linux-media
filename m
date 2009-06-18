Return-path: <linux-media-owner@vger.kernel.org>
Received: from as-10.de ([212.112.241.2]:41782 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763989AbZFROB2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 10:01:28 -0400
Date: Thu, 18 Jun 2009 16:01:29 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: ok more details: Re: bttv problem loading takes about several
	minutes
Message-ID: <20090618140129.GA13370@halim.local>
References: <28237.62.70.2.252.1245331454.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28237.62.70.2.252.1245331454.squirrel@webmail.xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
you can see at my dmesg output
[ 2282.430209] bttv: driver version 0.9.18 loaded

i have done
hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
make && make install 
reboot
No idea why I don't have the audiodev modparam?
Regards
Halim

-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de
