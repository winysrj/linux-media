Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([75.149.91.89]:50042 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab1CKWnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 17:43:39 -0500
Date: Fri, 11 Mar 2011 16:43:39 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Matti Aaltonen <matti.j.aaltonen@nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: compilation warnings/errors
In-Reply-To: <4D7A69EB.3060200@redhat.com>
Message-ID: <alpine.DEB.1.10.1103111640550.3738@cnc.isely.net>
References: <4D7A69EB.3060200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 11 Mar 2011, Mauro Carvalho Chehab wrote:

> /home/mchehab/new_build/v4l/pvrusb2-v4l2.c: In function 'pvr2_v4l2_do_ioctl':
> /home/mchehab/new_build/v4l/pvrusb2-v4l2.c:798:23: warning: variable 'cap' set but not used [-Wunused-but-set-variable]

I will look into these.  I'm a little puzzled right now since silly 
stuff like this usually doesn't get by me.  Unfortunately I can't look 
at it right this minute.  Expect to hear from me on Sunday.

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
