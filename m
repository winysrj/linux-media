Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:52816 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab3GLHOR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 03:14:17 -0400
Received: from [10.2.0.64] (unknown [10.2.0.64])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id 2F571222AA
	for <linux-media@vger.kernel.org>; Fri, 12 Jul 2013 09:14:13 +0200 (CEST)
Message-ID: <51DFAC53.8000301@schinagl.nl>
Date: Fri, 12 Jul 2013 09:12:19 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [DTV Tables] Now also on github.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey all,

since I hadn't received any comment in the previous message (which was a 
reply only) I thought i get this through the list as well.

I have created a github repostiory [0] for the dtv-tables so that it is 
easier for people to fork and upstream new data.

I'm not a fan to using github and not having patches submitted to me/the 
mailing list, but this isn't source code, but data that I feel is 
important to have in the tree as fast as possible.

I wouldn't be surprised that at some point some random manufacturer puts 
a reference to this tree into their system, be it closed or open, and it 
would be nice that our tables be as up to date as possible.

The best workflow I can think of, is that I will merge requests on 
github, pull them to my local repository, send the commit to the ML list 
before pushing it to linuxtv.org, but if better ideas arise, I'm all ears.

Oliver
