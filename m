Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:47009 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbcFZOaB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2016 10:30:01 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Subject: media_build & cx23885
Message-ID: <bb9fb742-7975-5c9a-1abc-bfd1a456d462@mbox200.swipnet.se>
Date: Sun, 26 Jun 2016 16:29:51 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

if i use media_build and modprobe cx23885 i get:
# modprobe cx23885
modprobe: ERROR: could not insert 'cx23885': Exec format error

and on dmesg i get:
frame_vector: exports duplicate symbol frame_vector_create (owned by kernel)

any idea whats causing this?
this prevents one of my cards from working with media_build
