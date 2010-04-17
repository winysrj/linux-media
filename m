Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34744 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753871Ab0DQB6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 21:58:10 -0400
Received: from [192.168.1.2] (d-216-36-24-245.cpe.metrocast.net [216.36.24.245])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id o3H1w7Ix000842
	for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 01:58:08 GMT
Subject: "make spec" broken
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 16 Apr 2010 21:58:44 -0400
Message-Id: <1271469524.3120.1.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In an hg clone of the v4l-dvb tree, "make spec" is broken:

$ make spec
make -C /home/andy/cx18dev/cx18-audio/v4l spec
make[1]: Entering directory `/home/andy/cx18dev/cx18-audio/v4l'
make -C ../media-specs
make[2]: Entering directory `/home/andy/cx18dev/cx18-audio/media-specs'
make[2]: *** No rule to make target
`../v4l2-apps/test/capture-example.c', needed by `capture'.  Stop.
make[2]: Leaving directory `/home/andy/cx18dev/cx18-audio/media-specs'
make[1]: *** [spec] Error 2
make[1]: Leaving directory `/home/andy/cx18dev/cx18-audio/v4l'
make: *** [spec] Error 2
$ 

I assume due to the removal of the v4l2-apps to their own separate tree.

Regards,
Andy


