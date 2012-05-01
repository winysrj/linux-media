Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.a1a-server.de ([62.146.15.7]:56380 "EHLO
	hermes.a1a-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab2EALFQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 07:05:16 -0400
Subject: RDS help needed
From: Matthias Bock <mail@matthiasbock.net>
To: linux-media@vger.kernel.org, v4l2-library@linuxtv.org
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 01 May 2012 12:56:49 +0200
Message-ID: <1335869809.4592.14.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there!

I hacked a RDS TMC-message receiver to work on the serial port.

http://www.matthiasbock.net/wiki/?title=Kategorie:GNS_TrafficBox_FM9_RDS_TMC-Receiver

According to
 http://linuxtv.org/wiki/index.php/Radio_Data_System_(RDS)
already several different receivers are available for usage
with Linux but development of the RDS message daemon,
that would be required to collect, decode and distribute
the RDS messages to client applications
 http://rdsd.berlios.de/
kindof stucked, didn't progress since 2009 (!)

The available SVN sources only support
SAA6588-based RDS receivers.

Is RDS support still an important task to
someone on this list ?

Is there someone, who would consider assisting me a little
in writing some documentation on the RDS daemon project,
some code maybe, lateron some linux kernel modules ?

Cheers! Matthias


