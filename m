Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbaFQPc3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jun 2014 11:32:29 -0400
Message-ID: <53A05F8A.6060108@suse.cz>
Date: Tue, 17 Jun 2014 17:32:26 +0200
From: Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: MANY errors while building media docbooks
References: <539F2926.4020004@infradead.org>
In-Reply-To: <539F2926.4020004@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-06-16 19:28, Randy Dunlap wrote:
> on Linux v3.16-rc1, building docbooks to a separate build directory
> (mkdir DOC; make O=DOC htmldocs) gives me more than 12,000 lines like this:
> 
> grep: ./Documentation/DocBook//vidioc-subdev-g-fmt.xml: No such file or directory
> grep: ./Documentation/DocBook//vidioc-subdev-g-frame-interval.xml: No such file or directory
> grep: ./Documentation/DocBook//vidioc-subdev-g-selection.xml: No such file or directory
> grep: ./Documentation/DocBook//vidioc-subscribe-event.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-device-info.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-enum-entities.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-enum-links.xml: No such file or directory
> grep: ./Documentation/DocBook//media-ioc-setup-link.xml: No such file or directory


Seems to be another fallout of the relative path patches, I'll have a look.

Thanks,
Michal

