Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4134 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3LSIpw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 03:45:52 -0500
Message-ID: <52B2B21D.6010006@xs4all.nl>
Date: Thu, 19 Dec 2013 09:45:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v4 0/7] SDR API
References: <1387425606-7458-1-git-send-email-crope@iki.fi>
In-Reply-To: <1387425606-7458-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/19/2013 04:59 AM, Antti Palosaari wrote:
> Here is the full set of implementation.
> 
> But..... API Documentation is the really hard part as it is in XML format.
> I have wasted already quite too much time for it :/ The reason is that
> I don't have any XML editor, just plain text editor. Is there any WYSIWYG
> XML editor for Linux? If there is no even editor I wonder if it is wise at
> all to keep documentation in XML format...

If there is a GUI editor that works I am not aware of it. This page might be
useful:

http://www.tldp.org/HOWTO/html_single/DocBook-Demystification-HOWTO/#AEN253

I am just using a regular editor (vim) and it isn't as bad as it seems at first
sight. A lot of copy-and-paste from elsewhere generally does the trick :-)

DocBook is the kernel standard, so we're stuck with it. It's not my favorite
either, but that's life.

I use a little script to build a single html file (as is done by the daily
build):


---- cut here ------
#!/bin/sh

make DOCBOOKS=media_api.xml htmldocs
xmllint --noent --postvalid "<FULLPATH>/media-git/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
xmllint --noent --postvalid --noout /tmp/x.xml
xmlto html-nochunks -m Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media_api.xml
---- cut here ------

This builds only the media part, not all the other kernel docs, and it builds it as
a single file which is 1) easier to read and 2) catches some errors that are not
found if it is split into a zillion little html files.

In addition the line numbers of errors refer to the single /tmp/x.xml file, so the
line numbers are actually useful. Without that trick line numbers are pretty
meaningless since it is next to impossible to decipher to which file they map.

> We used Altova XMLSpy on our structured data formats course and I would like
> to see something similar.

If you find something that works, let us know :-)

Regards,

	Hans

> 
> regards
> Antti
> 
> Antti Palosaari (7):
>   v4l: add device type for Software Defined Radio
>   v4l: add new tuner types for SDR
>   v4l: 1 Hz resolution flag for tuners
>   v4l: add stream format for SDR receiver
>   v4l: define own IOCTL ops for SDR FMT
>   v4l: enable some IOCTLs for SDR receiver
>   v4l: add device capability flag for SDR receiver
> 
>  drivers/media/v4l2-core/v4l2-dev.c   | 26 +++++++++++--
>  drivers/media/v4l2-core/v4l2-ioctl.c | 75 ++++++++++++++++++++++++++++++------
>  include/media/v4l2-dev.h             |  3 +-
>  include/media/v4l2-ioctl.h           |  8 ++++
>  include/trace/events/v4l2.h          |  1 +
>  include/uapi/linux/videodev2.h       | 16 ++++++++
>  6 files changed, 114 insertions(+), 15 deletions(-)
> 

