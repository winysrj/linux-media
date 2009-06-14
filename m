Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1072 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZFNJet (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 05:34:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Subject: dib3000mc.c and dib7000p.c compiler warnings
Date: Sun, 14 Jun 2009 11:34:42 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906141134.43101.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

The daily build reports these warnings for dib3000mc.c and dib7000p.c:

/marune/build/v4l-dvb-master/v4l/dib3000mc.c: In 
function 'dib3000mc_i2c_enumeration':
/marune/build/v4l-dvb-master/v4l/dib3000mc.c:863: warning: the frame size of 
1508 bytes is larger than 1024 bytes

/marune/build/v4l-dvb-master/v4l/dib7000p.c: In 
function 'dib7000p_i2c_enumeration':
/marune/build/v4l-dvb-master/v4l/dib7000p.c:1341: warning: the frame size of 
1568 bytes is larger than 1024 bytes

In both cases a big state struct is allocated on the stack. Would it be 
possible to optimize that?

If you are not the right person to deal with this, who might it be?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
