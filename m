Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59559 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757810AbcCaR27 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 13:28:59 -0400
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Linux 4.6-rc1 Fix for regression introduced in [media] au0828: use
 v4l2_mc_create_media_graph()
Message-ID: <56FD5E5A.5030006@osg.samsung.com>
Date: Thu, 31 Mar 2016 11:28:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is urgent. I am running sanity tests on Linux 4.6-rc1 and found
that your fix to the regression introduced by

[media] au0828: use v4l2_mc_create_media_graph()
commit - 9822f4173f84cb7c592edb5e1478b7903f69d018

is missing in Linux 4.6-rc1

The link to the regression fix is:

https://patchwork.linuxtv.org/patch/33441/

Please include the above fix in your pull request for rc2

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com
