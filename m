Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:44991 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab0BVXvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:51:11 -0500
Message-ID: <4B831849.3090701@maxwell.research.nokia.com>
Date: Tue, 23 Feb 2010 01:50:33 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: hverkuil@xs4all.nl,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Chroma gain configuration
References: <829197381002212007q342fc01bm1c528a2f15027a1e@mail.gmail.com> <1266838852.3095.20.camel@palomino.walls.org>
In-Reply-To: <1266838852.3095.20.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Sun, 2010-02-21 at 23:07 -0500, Devin Heitmueller wrote:
>> I am doing some work on the saa711x driver, and ran into a case where
>> I need to disable the chroma AGC and manually set the chroma gain.
> 
> Sakari, Hans, or anyone else,

Hi Andy,

> On a somewhat related note, what is the status of the media controller
> and of file handles per v4l2_subdev.  Will Sakari's V4L file-handle
> changes be all we need for the infrastructure or is there more to be
> done after that?

There are three things:

- V4L2 file handles (and events)
- V4L2 subdev device nodes
- Media controller

The file handles and events appear to be fairly ready.

> I'd like to implement specific "technician controls", something an
> average user wouldn't use, for a few subdevs.

For that you'd need at least V4L2 subdev device nodes, preferrably also
Media controller e.g. for the user space to know the two devices indeed
are connected to the same higher level device. File handles do not
matter here; it's just a generic way to store file handle specific data,
required by events, for example.

Subdev device nodes and Media controller patches live in Laurent's tree
at linuxtv.org at the moment.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
