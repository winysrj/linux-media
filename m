Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35968 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbaIMAen (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 20:34:43 -0400
Message-ID: <5413911F.8070302@osg.samsung.com>
Date: Fri, 12 Sep 2014 18:34:39 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: "Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	hverkuil@xs4all.nl
CC: linux-media@vger.kernel.org
Subject: v4l2_fops - poll and open
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro/Hans,

It turns out au0828 driver does init tuner from its
v4l2_fops read and poll. If an analog app comes in
and does a read or poll, digital could get disrupted.
Do you recommend adding token access to these??

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
