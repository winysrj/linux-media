Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40973 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1JGPer (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 11:34:47 -0400
Date: Fri, 7 Oct 2011 18:34:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 0/7] Move functionality to libraries, debug
 changes
Message-ID: <20111007153443.GC8908@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patchset moves the string parsing functionality to libraries from the
test program, making the libraries much more useful.

Printing informative messages is also left to debug handler; the libraries
won't print anything anymore. Error messages are also printed by media-ctl.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
