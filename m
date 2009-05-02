Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4853 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZEBLCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 May 2009 07:02:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Manu Abraham <abraham.manu@gmail.com>
Subject: stv090x.c compile warning
Date: Sat, 2 May 2009 13:02:03 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905021302.03415.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manu,

Compiling stv090x.c against 2.6.30-rc4 gives me this compile warning:

/home/hans/work/src/v4l/v4l-dvb/v4l/stv090x.c: In 
function 'stv090x_chk_tmg':
/home/hans/work/src/v4l/v4l-dvb/v4l/stv090x.c:2544: warning: 'tmg_cpt' may 
be used uninitialized in this function

Looking at the code this variable is indeed uninitialized. I'm pretty sure 
it should be initialized to 0, can you confirm this?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
