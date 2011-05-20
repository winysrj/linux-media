Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933731Ab1ETHLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 03:11:30 -0400
Message-ID: <4DD6141A.8030907@redhat.com>
Date: Fri, 20 May 2011 09:11:22 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Yordan Kamenov <ykamenov@mm-sol.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [libv4l-mcplugin PATCH 0/3] Media controller plugin for libv4l2
References: <cover.1305804894.git.ykamenov@mm-sol.com>
In-Reply-To: <cover.1305804894.git.ykamenov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

So judging from the directory layout, this is supposed to be a separate
project, and not part of v4l-utils / libv4l, right?

WRT my merging plans for libv4l. I've recently done some much needed
work to better support high-res usb cameras. I plan to do a 0.8.4 release
with that work included real soon. Once that is done I'll change the version
in the Make.rules to 0.9.0-test and merge the plugin. Then we'll have
some 0.9.x releases followed by some 0.9.9x release (all testing releases)
followed by a 0.10.0 which should be the first stable release with plugin
support.

Regards,

Hans


On 05/19/2011 02:36 PM, Yordan Kamenov wrote:
> Hi,
>
> This is the Media Controller plugin for libv4l. It uses libv4l2 plugin support
> which is accepted by Hans De Goede, but not yet included in mainline libv4l2:
> http://www.spinics.net/lists/linux-media/msg32017.html
>
> The plugin allows a traditional v4l2 applications to work with Media Controller
> framework. The plugin is loaded when application opens /dev/video0 and it
> configures the media controller and then all ioctl's by the applicatin are
> handled by the plugin.
>
> The plugin implements init, close and ioctl callbacks. The init callback
> checks it's input file descriptor and if it coresponds to /dev/video0, then
> the media controller is initialized and appropriate pipeline is created.
> The close callback deinitializes the pipeline, and closes the media device.
> The ioctl callback is responsible to handle ioctl calls from application by
> using the media controller pipeline.
>
> The plugin uses media-ctl library for media controller operations:
> http://git.ideasonboard.org/?p=media-ctl.git;a=summary
>
> The plugin is divided in three separate patches:
>   * Media Controller pipelines initialization, configuration and destruction
>   * v4l operations - uses some functionality from the first one
>   * Plugin interface operations (init, close and ioctl) - uses functionality
>     from first two
>
>
>
> Yordan Kamenov (3):
>    Add files for media controller pipelines
>    Add files for v4l operations
>    Add libv4l2 media controller plugin interface files
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
