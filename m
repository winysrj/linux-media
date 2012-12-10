Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41660 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2LJVPL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:15:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TiAh7-0007rt-TZ
	for linux-media@vger.kernel.org; Mon, 10 Dec 2012 22:15:21 +0100
Received: from cpc3-heme9-2-0-cust93.9-1.cable.virginmedia.com ([81.111.156.94])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 22:15:21 +0100
Received: from mariofutire by cpc3-heme9-2-0-cust93.9-1.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2012 22:15:21 +0100
To: linux-media@vger.kernel.org
From: andrea <mariofutire@googlemail.com>
Subject: Understanding v4l2-ctl flags
Date: Mon, 10 Dec 2012 21:14:59 +0000
Message-ID: <ka5jci$q8q$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Logitech webcam under PWC.
I've managed to use v4l2-ctl to change come controls, but some of them seem to be unsupported.

v4l2-ctl reports the following flags

inactive
update
slider
write-only
** no flags at all **

e.g.

restore_factory_settings (button) : flags=update, write-only

What is the meaning of them?
I can guess that inactive means unsupported, but do I care about the others?

