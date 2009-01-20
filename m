Return-path: <linux-media-owner@vger.kernel.org>
Received: from txslsmtp1.vzwmail.net ([66.174.85.155]:55547 "EHLO
	txslsmtp1.vzwmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZATAck (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 19:32:40 -0500
Received: from [70.193.10.197] (smtp.vzwmail.net [66.174.85.25])
	(authenticated bits=0)
	by txslsmtp1.vzwmail.net (8.12.9/8.12.9) with ESMTP id n0K0DMJf016440
	for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 00:13:32 GMT
Message-ID: <49751737.1020101@vzwmail.net>
Date: Mon, 19 Jan 2009 17:13:43 -0700
From: "T.P. Reitzel" <4066724035@vzwmail.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gspca_spca505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just pulled mercurial's v4l-dvb for Bluewhite64's 2.6.27.7 kernel.
This spca505 driver for Intel's PC Camera Pro, 0733:0430 isn't even
functioning. The MMAP feature of this driver just displays a screen of
horizontal green lines. Furthermore, M. Xhaard stripped the external
composite feature from this driver a few years ago and no one has yet
added it back. If you visit the original website for this driver on
sourceforge.net, you'll see the original driver for this video camera
including composite support. As it is, the driver for this camera is
totally inoperative.

I thank you.
------------------------------------------------------------------------
