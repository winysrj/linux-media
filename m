Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35243 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZCMKVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 06:21:16 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: Steven Toth <stoth@linuxtv.org>
Subject: About multifrontend - initalisation of dvb_frontend.id value
Date: Fri, 13 Mar 2009 11:21:05 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131121.06048.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven!

You merged / developed multifrontend support. And patch 9222:44d82b67e0b8 
added a field id to struct dvb_frontend. So who is responsible for setting 
this to useful value? I found no comment about this, better would be to add 
one.

As I discovered earlier a lot of frontend drivers use kmalloc so the fields 
not used by them are not properly set to zero.

Is it required that frontend/demod drivers use kzalloc for all unknown/maybe 
new fields to be properly set?

Regards
Matthias
