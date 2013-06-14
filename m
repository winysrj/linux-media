Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab3FNNeM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 09:34:12 -0400
Date: Fri, 14 Jun 2013 10:34:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: Doing a v4l-utils-1.0.0 release
Message-ID: <20130614103404.3dc2c4bf@redhat.com>
In-Reply-To: <51BAC2F6.40708@redhat.com>
References: <51BAC2F6.40708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Jun 2013 09:15:02 +0200
Hans de Goede <hdegoede@redhat.com> escreveu:

> Hi All,
> 
> IIRC the 0.9.x series were meant as development releases leading up to a new
> stable 1.0.0 release. Lately there have been no maintenance 0.8.x releases
> and a lot of interesting development going on in the 0.9.x, while at the
> same time there have been no issues reported against 0.9.x (iow it seems
> stable).
> 
> So how about taking current master and releasing that as a 1.0.0 release ?

Fine for me. 

There are 5 patches floating at patchwork to improve the DVB-S support 
with different types of DiSEqC, but applying them would break library support
for tvd. So, they won't be applied as-is, and Guy needs to take some other
approach. As he is also planning to add support there for rotors, it
looks ok to postpone such changes to a latter version.

So, feel free to bump it to version 1.0.

Regards,
Mauro
-- 

Cheers,
Mauro
