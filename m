Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65218 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0AVCmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 21:42:38 -0500
Received: by yxe17 with SMTP id 17so649236yxe.33
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 18:42:37 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 10:42:36 +0800
Message-ID: <f74f98341001211842y6dabbe97s1d7c362bac2d87b8@mail.gmail.com>
Subject: About MPEG decoder interface
From: Michael Qiu <fallwind@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

  How can I export my MPEG decoder control interface to user space?
  Or in other words, which device file(/dev/xxx) should a proper
driver for mpeg decoder provide?
  And, in linux dvb documents, all the frontend interface looks like
/dev/dvb/adapter/xxx, it looks just for PCI based tv card.
  If it's not a TV card, but a frontend for a embedded system without
PCI, which interface should I use?


Best regards
Michael Qiu
