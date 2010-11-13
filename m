Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1943 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0KMR5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Nov 2010 12:57:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>
Subject: Re: [PATCH 00/10] MCDE: Add frame buffer device driver
Date: Sat, 13 Nov 2010 18:57:15 +0100
Cc: Alex Deucher <alexdeucher@gmail.com>,
	Jimmy RUBIN <jimmy.rubin@stericsson.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Dan JOHANSSON <dan.johansson@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com> <201011131254.24196.hverkuil@xs4all.nl> <C832F8F5D375BD43BFA11E82E0FE9FE0081B425E92@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <C832F8F5D375BD43BFA11E82E0FE9FE0081B425E92@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011131857.15285.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, November 13, 2010 18:26:45 Marcus LORENTZON wrote:
> Hi Hans,
> MCDE is for both "video" and graphics. That is, it supports YUV and RGB buffers to be blended onto a background during scanout. And as most SOCs it supports normal CRTC type of continous scanout like LCD and MIPI DPI/DSI video mode and command mode scanout like MIPI DBI/DSI. I guess you have seen the slides of U8500 published at the last L4L2 smmit in Helsinki (http://linuxtv.org/downloads/presentations/summit_jun_2010/ste_V4L2_developer_meeting.pdf).

I'm an idiot. I should have checked that presentation in the first place. I was
wondering whether this driver corresponded to what we discussed in Helsinki or
whether it was new development. Now I know :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
