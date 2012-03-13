Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52996 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159Ab2CMJhF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Mar 2012 05:37:05 -0400
Received: by eaaq12 with SMTP id q12so72096eaa.19
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2012 02:37:04 -0700 (PDT)
Message-ID: <4F5F1531.7030300@gmail.com>
Date: Tue, 13 Mar 2012 10:36:49 +0100
From: Marek Ochaba <maolynx@gmail.com>
MIME-Version: 1.0
To: bob.news@non-elite.com
CC: linux-media@vger.kernel.org
Subject: Re: DVB-S2 multistream support
References: <loom.20120307T170824-19@post.gmane.org>
In-Reply-To: <loom.20120307T170824-19@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Compilation and instalation process is described in README_TBS6921 file.

- extract linux-tbs-drivers.tar.bz2 archive
- run configuration script v4l/tbs-x86_r3.sh or v4l/tbs-x86_64.sh
- compile by make
- make install
  this put driver to right place

I downloaded source of driver from TBS dtv site and it work well for me (on
Debian 5.0)

--
Marek Ochaba

