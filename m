Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36002 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbbAYJdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 04:33:50 -0500
Received: by mail-ig0-f174.google.com with SMTP id b16so4100823igk.1
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 01:33:49 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 25 Jan 2015 09:33:49 +0000
Message-ID: <CAOBYczptqxkRXVPs3UuKJxEtm7uf9=yF9DgpF+e5mqbj6wZRrQ@mail.gmail.com>
Subject: usb3 + 2 x pctv290e issues
From: Robin Becker <robin@reportlab.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Has anyone else her had the problem described in

https://bugzilla.kernel.org/show_bug.cgi?id=65021

ie complete xhci freeze when a second pctv290e is accessed with vlc.
I'm wondering if this is a problem specific to em28xx or the pctv290e
or to this kind of device (ie dvb usb).
-- 
Robin Becker
