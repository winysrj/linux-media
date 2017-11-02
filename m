Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:52167 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751628AbdKBCDw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 22:03:52 -0400
Message-ID: <1509587669.31043.66.camel@perches.com>
Subject: MAINTAINERS has a AS3645A LED FLASH duplicated section in -next
From: Joe Perches <joe@perches.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 01 Nov 2017 18:54:29 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MAINTAINERS is not supposed to have duplicated sections.
Can you both please resolve this?

AS3645A LED FLASH CONTROLLER DRIVER
M:	Sakari Ailus <sakari.ailus@iki.fi>
L:	linux-leds@vger.kernel.org
S:	Maintained
F:	drivers/leds/leds-as3645a.c

AS3645A LED FLASH CONTROLLER DRIVER
M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
L:	linux-media@vger.kernel.org
T:	git git://linuxtv.org/media_tree.git
S:	Maintained
F:	drivers/media/i2c/as3645a.c
F:	include/media/i2c/as3645a.h
