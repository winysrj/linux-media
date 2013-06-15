Return-path: <linux-media-owner@vger.kernel.org>
Received: from venus.vo.lu ([80.90.45.96]:53744 "EHLO venus.vo.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab3FOKdw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Jun 2013 06:33:52 -0400
Date: Sat, 15 Jun 2013 12:33:37 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Doing a v4l-utils-1.0.0 release
Message-ID: <20130615123337.1ba83c63@borg.bxl.tuxicoman.be>
In-Reply-To: <20130614103404.3dc2c4bf@redhat.com>
References: <51BAC2F6.40708@redhat.com>
	<20130614103404.3dc2c4bf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Fri, 14 Jun 2013 10:34:04 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em Fri, 14 Jun 2013 09:15:02 +0200
> Hans de Goede <hdegoede@redhat.com> escreveu:
> 
> > Hi All,
> > 
> > IIRC the 0.9.x series were meant as development releases leading up
> > to a new stable 1.0.0 release. Lately there have been no
> > maintenance 0.8.x releases and a lot of interesting development
> > going on in the 0.9.x, while at the same time there have been no
> > issues reported against 0.9.x (iow it seems stable).
> > 
> > So how about taking current master and releasing that as a 1.0.0
> > release ?
> 
> Fine for me. 
> 
> There are 5 patches floating at patchwork to improve the DVB-S
> support with different types of DiSEqC, but applying them would break
> library support for tvd. So, they won't be applied as-is, and Guy
> needs to take some other approach. As he is also planning to add
> support there for rotors, it looks ok to postpone such changes to a
> latter version.

Can we wait a little bit more like a week max ?
I'd like to see the polarization stuff fixed because otherwise you
can't use sat at all with libdvbv5.

I'll work on the new patches this weekend. I'll hopefully have
something today.
I'll see what I can do wrt DiSEqC stuff but that can definitely wait a
latter release.

  Guy


