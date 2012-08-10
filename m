Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57516 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab2HJPVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 11:21:34 -0400
Received: by ggdk6 with SMTP id k6so1695292ggd.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 08:21:34 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 15:21:33 +0000
Message-ID: <CAFomkUBmdE6omBfVrg3AsaXFHxSJRuTszmyMD5pU21TT7FxeVw@mail.gmail.com>
Subject: [Announcement] pcimax3000+ (RDS-transmitter) control tool
From: Konke Radlow <koradlow@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
during the last weeks I've been working on a RDS (Radio Data System)
decoding library
(libv4l2rds) and a corresponding test and control tool (rds-ctl), that
might make it into v4l soon.

In the course of this process I created a command line tool for
controlling the PCIMAX3000+
RDS-transmission card.
http://www.pcs-electronics.com/3000-stereo-transmitter-card-p-1664.html?

The tool was used to test the library and has reached a stage where it
is feature complete
and easy to use and setup. For this reason I wanted to share the code
in case somebody
is interested in setting up his own radio station, or test RDS :)

The most recent version of the tool can always be found in my repository:
https://github.com/koradlow/pcimax-ctl

Regards,
Konke
