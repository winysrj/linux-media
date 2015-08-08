Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56773 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbHHLdg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Aug 2015 07:33:36 -0400
Date: Sat, 8 Aug 2015 08:33:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: media-workshop@linuxtv.org, linux-media@vger.kernel.org
Subject: [RFC] Media graph flow for an hybrid device as discussed at the
 media workshop
Message-ID: <20150808083330.7daf111f@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During the discussions at the Media Workshop, we came with some dot files that
would describe a hybrid PC-consumer TV stick with radio, analog video, analog
TV and digital TV on it.

I consolidated all the dot files we've worked there, and added the
connectors for RF, S-Video and Composite.

The dot file and the corresponding picture is at:
	http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v2.dot
	http://linuxtv.org/downloads/presentations/mc_ws_2015/dvb-pipeline-v2.png

As my plan is to start working on some real driver to produce such graph,
please validate if the entities, interfaces, data links and interface links
are correct, and if the namespace nomenclature is ok, or if I miss something.

Thanks!
Mauro
