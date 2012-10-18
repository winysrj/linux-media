Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:37091 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab2JRL0O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Oct 2012 07:26:14 -0400
Received: from [10.2.0.248] (unknown [10.2.0.248])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id E5DD922D83
	for <linux-media@vger.kernel.org>; Thu, 18 Oct 2012 13:26:11 +0200 (CEST)
Message-ID: <507FE752.6010409@schinagl.nl>
Date: Thu, 18 Oct 2012 13:26:10 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [RFC] Initial scan files troubles and brainstorming
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello list,

I was talking to someone over at tvheadend and was told that the 
linux-media initial scan files tend to be often very out dated. Also 
when newer files are submitted, requests to merge them are simply being 
ignored. Obviously I have zero proof to back those claims. True or not, 
they have decided to keep a local copy and try to keep that up to date 
as possible. One of the reasons to take this approach, is because major 
distro's also do it in this way.

This obviously results in a duplication of work and since it's factual 
data really wasted resources, no central repository of said factual 
data, but spread and makes it confusing on top of that for users of this 
data.

Now I don't know the proper solution or if it really is a problem. Well 
it appears to be so I guess ;)

Something that comes to mind, is to split off the initial scan files 
from the dvb-apps package and have a seperate git tree for it, like for 
example the firmware git tree. I feel this has several advantages over 
the current setup.

One could have /usr/share/dvb/ as a git tree and simply pull to have an 
up to date tree.
Initialscan file 'users (as in developers)' can more easily clone it and 
do pull requests.
Possibly more lenient commit access, e.g. allow a 'trusted' developer of 
a dvb project to have commit rights, without much risk of breaking any 
source code.
Other things I haven't thought of yet.
Since there really isn't a 'stable' release, current trunk can be 
considered the go to release, unverified changes could live in a branch?

Again, if everybody can firmly claim there is no problem and that the 
initial scanfiles are updated nearly when an actually change takes 
place, then we should try convince downstream maintainers of course.

Anyway, this is just something that was on my mind and wanted some 
feedback on.

Oliver
