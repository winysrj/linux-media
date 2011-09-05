Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49814 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1IEPze (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 11:55:34 -0400
Date: Mon, 5 Sep 2011 18:55:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	s.nawrocki@samsung.com
Subject: [RFC] Reserved fields in v4l2_mbus_framefmt, v4l2_subdev_format
 alignment
Message-ID: <20110905155528.GB1308@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I recently came across a few issues in the definitions of v4l2_subdev_format
and v4l2_mbus_framefmt when I was working on sensor control that I wanted to
bring up here. The appropriate structure right now look like this:

include/linux/v4l2-subdev.h:
---8<---
/**
 * struct v4l2_subdev_format - Pad-level media bus format
 * @which: format type (from enum v4l2_subdev_format_whence)
 * @pad: pad number, as reported by the media API
 * @format: media bus format (format code and frame size)
 */
struct v4l2_subdev_format {
        __u32 which;
        __u32 pad;
        struct v4l2_mbus_framefmt format;
        __u32 reserved[8];
};
---8<---

include/linux/v4l2-mediabus.h:
---8<---
/**
 * struct v4l2_mbus_framefmt - frame format on the media bus
 * @width:      frame width
 * @height:     frame height
 * @code:       data format code (from enum v4l2_mbus_pixelcode)
 * @field:      used interlacing type (from enum v4l2_field)
 * @colorspace: colorspace of the data (from enum v4l2_colorspace)
 */
struct v4l2_mbus_framefmt {
        __u32                   width;
        __u32                   height;
        __u32                   code;
        __u32                   field;
        __u32                   colorspace;
        __u32                   reserved[7];
};
---8<---

Offering a lower level interface for sensors which allows better control of
them from the user space involves providing the link frequency to the user
space. While the link frequency will be a control, together with the bus
type and number of lanes (on serial links), this will define the pixel
clock.

<URL:http://www.spinics.net/lists/linux-media/msg36492.html>

After adding pixel clock to v4l2_mbus_framefmt there will be six reserved
fields left, one of which will be further possibly consumed by maximum image
size:

<URL:http://www.spinics.net/lists/linux-media/msg35949.html>

Frame blanking (horizontal and vertical) and number of lanes might be needed
in the struct as well in the future, bringing the reserved count down to
two. I find this alarmingly low for a relatively new structure definition
which will potentially have a few different uses in the future.

The another issue is that the size of the v4l2_subdev_format struct is not
aligned to a power of two. Instead of the intended 32 u32's, the size is
actually 22 u32's.

The interface is present in the 3.0 and marked experimental. My proposal is
to add reserved fields to v4l2_mbus_framefmt to extend its size up to 32
u32's. I understand there are already few which use the interface right now
and thus this change must be done now or left as-is forever.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
