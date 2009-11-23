Return-path: <linux-media-owner@vger.kernel.org>
Received: from paja.nic.funet.fi ([193.166.3.10]:63089 "EHLO paja.nic.funet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbZKWRTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:19:44 -0500
Received: (from localhost user: 'kouhia' uid#241 fake: STDIN
	(kouhia@paja.nic.funet.fi)) by nic.funet.fi id S77688AbZKWPYcKKXeQ
	for <linux-media@vger.kernel.org>; Mon, 23 Nov 2009 17:24:32 +0200
From: Juhana Sadeharju <kouhia@nic.funet.fi>
To: linux-media@vger.kernel.org
Subject: Video extractor?
Message-Id: <S77688AbZKWPYcKKXeQ/20091123152432Z+8457@nic.funet.fi>
Date: Mon, 23 Nov 2009 17:24:32 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Is there a video editor which can be used to extract pieces
of video to file? Two of the editors in Ubuntu failed to load
the DVB TS streamfile, Kino converted it to DV format, and slowly.
That is bad. And I don't know what DV format is, and how to convert
it losslessly back to DVB TS format.

Simplest would be if Xine would be equipped with "mark begin",
"mark end", and "extract to file" commands. The marks should
be at 188 byte packet boundaries. I could write viewer myself
using libxine but it takes time. Are Xine people reading this?

In any case, I got feeling basic tools are still missing from
Linux media software catalogue. I need the tool in my projects.

Juhana
