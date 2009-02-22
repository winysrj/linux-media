Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:45776 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZBVTcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 14:32:08 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: struct dvb_frontend not initialized correctly / random id value since MFE merge
Date: Sun, 22 Feb 2009 20:31:59 +0100
Cc: Steven Toth <stoth@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902222031.59364.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there!

MFE patches added a variable "id" to struct dvb_frontend.
This variable seems to be uninitialized for some drivers.

The result is for my skystar2 card (using stv0299 frontend) it sometimes is 0 
as it should but sometimes it is a random value, so I get this register 
message:
DVB: registering adapter 1 frontend -10551321 (ST STV0299 DVB-S)

The related kernel thread then also has a strange name like:
kdvb-ad-1-fe--1

The same happens for my dvb-ttpci card using ves1x93 frontend.

Now I wonder if all frontend drivers should be switched to use kzalloc instead 
of kmalloc for struct dvb_frontend, or if it is the bridge driver that should 
init the id-value.
What about all other members of this struct? Will they be initialized 
correctly?

Regards
Matthias
