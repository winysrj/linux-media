Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.230]:47696 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0HKJVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Aug 2010 05:21:44 -0400
Subject: A problem with http://git.linuxtv.org/media_tree.git
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-MS/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <4C614294.7080101@redhat.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1280758003-16118-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <201008091838.13247.hverkuil@xs4all.nl>
	 <1281425501.14489.7.camel@masi.mnp.nokia.com>
	 <b141c1c6bfc03ce320b94add5bb5f9fc.squirrel@webmail.xs4all.nl>
	 <1281441830.14489.27.camel@masi.mnp.nokia.com>
	 <4C614294.7080101@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 12:21:26 +0300
Message-ID: <1281518486.14489.43.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi.

I cloned your tree at 	http://linuxtv.org/git/media_tree.git and checked
out the origin/staging/v2.6.37 branch and the
Documentation/video4linux/v4l2-controls.txt  just isn't there. I asked
one of my colleagues to do the same and the result was also the same.

The latest commit in this branch is:

commit 80f1bb8ad61b56597ef2557cc7c67d8876247e6d
Merge: 2763aca... fc1caf6...
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Fri Aug 6 10:50:25 2010 -0300

Please check what's wrong...

Thanks,
Matti A.


