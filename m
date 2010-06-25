Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:55578 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0FYDEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jun 2010 23:04:55 -0400
Message-ID: <4C241CBA.7040707@vorgon.com>
Date: Thu, 24 Jun 2010 20:04:26 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: ERROR: cKbdRemote: Invalid argument
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not sure what caused this, but the remote was working and I did an 
apt-get update/upgrade and then it wasn't. Now the syslog is getting 
this repeating. Don't seem to have to use the remote for another entry 
to be added to the log.

Jun 24 19:36:33 x64VDR vdr: [4903] ERROR: cKbdRemote: Invalid argument

Using Debian Squeeze. remote is on a nexus-s and using ir_kbd_i2c
