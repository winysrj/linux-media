Return-path: <linux-media-owner@vger.kernel.org>
Received: from zencphosting06.zen.co.uk ([82.71.204.9]:38051 "EHLO
	zencphosting06.zen.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbcF0MwA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 08:52:00 -0400
Subject: Re: [PATCH v5 0/9] Output raw touch data via V4L2
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
 <30c68dab-b970-03d5-797b-3376d9d0dc10@xs4all.nl>
 <8be600b6-a424-ddda-8672-1aed4e925fe8@itdev.co.uk>
 <693d1756-dab4-b05c-0607-f391f63f1d62@xs4all.nl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Nick Dyer <nick.dyer@itdev.co.uk>
Message-ID: <39b18d15-848b-bf28-4ff2-a5216846fb6b@itdev.co.uk>
Date: Mon, 27 Jun 2016 13:51:54 +0100
MIME-Version: 1.0
In-Reply-To: <693d1756-dab4-b05c-0607-f391f63f1d62@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/06/2016 13:22, Hans Verkuil wrote:
> On 06/27/2016 01:57 PM, Nick Dyer wrote:
> 2) Alternatively, if we want to keep using BUF_TYPE_VIDEO_CAPTURE, then:
> 
> - we keep V4L2_CAP_TOUCH which is combined with CAP_VIDEO_CAPTURE (and perhaps
>   VIDEO_OUTPUT in the future). The CAP_TOUCH just says that this is a touch
>   device, not a video device, but otherwise it acts the same.
> 
> I'd go with 2, since I see no reason to add a new BUF_TYPE for this.
> It acts exactly like video after all, with only a few restrictions (i.e. no
> colorspace info or interlaced). And adding a new BUF_TYPE will likely break
> the existing sur40 app.

OK, I will rework with this approach.
