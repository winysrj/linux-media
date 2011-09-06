Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:34425 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1IFLHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 07:07:49 -0400
Date: Tue, 6 Sep 2011 14:07:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [RFC/PATCH 0/1] Ignore ctrl_class
Message-ID: <20110906110742.GE1393@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I remember being in a discussion a while ago regarding the requirement of
having all the controls belonging to the same class in
VIDIOC_{TRY,S,G}_EXT_CTRLS. The answer I remember was that there was a
historical reason for this and it no longer exists.

So here's the patch.

The changes in drivers were really simple but have not been tested. The
changes in the control framework have been tested for querying, getting and
setting extended and non-extended controls.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
