Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:54985 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab0A3KEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 05:04:37 -0500
Message-ID: <4B640420.3040607@freemail.hu>
Date: Sat, 30 Jan 2010 11:04:16 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: pac7302 sporadic plug-in problem fix for 2.6.33?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Jean-Francois and Mauro,

I just compiled the vanilla 2.6.33-rc6 kernel and tested together
with Labtec Webcam 2200.

I realized that this version still has the plug-in problem which was
fixed at

  http://linuxtv.org/hg/~jfrancois/gspca/rev/ea88b3abee04

What do you think, is it possible that this simple but important
patch will be pulled to final 2.6.33? If I understand correctly
this kind of bugfixes are normally accepted in the current development
phase.

Regards,

	Márton Németh
