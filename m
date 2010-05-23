Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59584 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172Ab0EWRRR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 13:17:17 -0400
Received: from [192.168.1.2] (d-216-36-24-245.cpe.metrocast.net [216.36.24.245])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id o4NHHEs8019892
	for <linux-media@vger.kernel.org>; Sun, 23 May 2010 17:17:14 GMT
Subject: Q: Setting up a GIT repository on linuxtv.org
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 13:17:24 -0400
Message-ID: <1274635044.2275.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm a GIT idiot, so I need a little help on getting a properly setup
repo at linuxtv.org.  Can someone tell me if this is the right
procedure:

$ ssh -t awalls@linuxtv.org git-menu
        (clone linux-2.6.git naming it v4l-dvb  <-- Is this right?)
$ git clone \
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git \
        v4l-dvb
$ cd v4l-dvb
$ git remote add linuxtv http://linuxtv.org/git/v4l-dvb.git
$ git remote add awalls ssh://linuxtv.org/git/awalls/v4l-dvb.git
$ git remote update

and then what?  Something like

$ git checkout -b cxfoo linuxtv/master   

to develop changes for some Conexant chips for example???


Thanks,
Andy


