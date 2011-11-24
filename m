Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38934 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab1KXQMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 11:12:32 -0500
Date: Thu, 24 Nov 2011 18:12:28 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: snjw23@gmail.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: [RFC/PATCH 0/3] 64-bit integer menus
Message-ID: <20111124161228.GA29342@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patchset, which I'm sending as RFC since it has not been really tested
(including compiling the vivi patch), adds 64-bit integer menu controls. The
control items in the integer menu are just like in regular menus but they
are 64-bit integers instead of strings.

I'm also pondering whether to assign 1 to ctrl->step for menu type controls
as well but haven't checked what may have been the original reason to
implement it as it is now implemented.

The reason why I don't use a union for qmenu and qmenu_int in
v4l2_ctrl_config is that a lot of drivers use that field in the initialiser
and GCC < 4.6 does not support initialisers with anonymous unions.

Similar union is created in v4l2_querymenu but I do not see this as a
problem since I do not expect initialisers to be used with this field in the
user space code.

Comments and questions are welcome.

Kind regards,


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
