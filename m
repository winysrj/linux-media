Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:48479 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbZDHRWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2009 13:22:13 -0400
Date: Wed, 8 Apr 2009 12:22:10 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [RFC] Anticipating lirc breakage
In-Reply-To: <20090407120209.1d42bacd@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904081218260.18157@cnc.isely.net>
References: <20090406174448.118f574e@hyperion.delvare>
 <Pine.LNX.4.64.0904070049470.2076@cnc.isely.net> <20090407120209.1d42bacd@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Apr 2009, Jean Delvare wrote:

> I'll rework my patch set to implement strategy #1 and post it when I'm
> done. As far as I can see this should be very similar to my original
> attempt, with just "ir_video" devices instead or "ir-kbd" devices, and
> also fixes for the minor issues that have been reported.
> 
> Do you want me to include pvrusb2 in my new patch set, or should I still
> leave it to you?

If you were to include pvrusb2, you would also need the changeset which 
expands the "IR scheme" handling to make it possible to correctly select 
when to bind the driver.  But Mauro hasn't pulled that so you can't 
easily build on it right now.  And as I understand it, the only real 
impact in the second changeset in the pending series is just the name of 
the module (i.e. change "ir-kbd" to "ir_video").

It's extra work for you to do this.  So just let me deal with it.  If my 
understanding above is correct, I'll just fix the second patch and the 
pvrusb2 driver should be ready to go for this.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
