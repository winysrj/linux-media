Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:32977 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622Ab1ESMgY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 08:36:24 -0400
From: Yordan Kamenov <ykamenov@mm-sol.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: [libv4l-mcplugin PATCH 0/3] Media controller plugin for libv4l2
Date: Thu, 19 May 2011 15:36:09 +0300
Message-Id: <cover.1305804894.git.ykamenov@mm-sol.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This is the Media Controller plugin for libv4l. It uses libv4l2 plugin support
which is accepted by Hans De Goede, but not yet included in mainline libv4l2:
http://www.spinics.net/lists/linux-media/msg32017.html

The plugin allows a traditional v4l2 applications to work with Media Controller
framework. The plugin is loaded when application opens /dev/video0 and it
configures the media controller and then all ioctl's by the applicatin are
handled by the plugin.

The plugin implements init, close and ioctl callbacks. The init callback
checks it's input file descriptor and if it coresponds to /dev/video0, then
the media controller is initialized and appropriate pipeline is created.
The close callback deinitializes the pipeline, and closes the media device.
The ioctl callback is responsible to handle ioctl calls from application by
using the media controller pipeline.

The plugin uses media-ctl library for media controller operations:
http://git.ideasonboard.org/?p=media-ctl.git;a=summary

The plugin is divided in three separate patches:
 * Media Controller pipelines initialization, configuration and destruction
 * v4l operations - uses some functionality from the first one
 * Plugin interface operations (init, close and ioctl) - uses functionality
   from first two



Yordan Kamenov (3):
  Add files for media controller pipelines
  Add files for v4l operations
  Add libv4l2 media controller plugin interface files

