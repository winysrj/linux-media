Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50783 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0CAW3I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 17:29:08 -0500
Message-ID: <4B8C3FAE.6060509@infradead.org>
Date: Mon, 01 Mar 2010 19:29:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How do private controls actually work?
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>	 <201003010957.49198.laurent.pinchart@ideasonboard.com>	 <829197381003010107m79ff65bajde4da911eafc6740@mail.gmail.com>	 <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl> <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>
In-Reply-To: <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Devin Heitmueller wrote:
> On Mon, Mar 1, 2010 at 4:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> New private controls should not use V4L2_CID_PRIVATE_BASE at all. That
>> mechanism was a really bad idea. Instead a new control should be added to
>> the appropriate control class and with a offset >= 0x1000. See for example
>> the CX2341X private controls in videodev2.h.

The better is to create a device-specific control, if the parameter you want 
to control is really specific to just one chip family. Otherwise, just add a 
new "common" control to the API.

> 
> http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/a7d50db75420

FYI, v42-apps were moved to a separate tree.

-- 

Cheers,
Mauro
