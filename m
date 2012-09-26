Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60090 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2IZIHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 04:07:05 -0400
Received: by oagh16 with SMTP id h16so286716oag.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 01:07:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926075427.GA14040@valkosipuli.retiisi.org.uk>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
 <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com>
 <20120926074240.GM12025@valkosipuli.retiisi.org.uk> <CA+V-a8vBXP=af_zWgiQzUhNBvexC6joddW7hioMqGziSTK9Dqw@mail.gmail.com>
 <20120926075427.GA14040@valkosipuli.retiisi.org.uk>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 26 Sep 2012 13:36:44 +0530
Message-ID: <CA+V-a8t4Nx1Oz0d6+JJKOQciuGy5w_XgEfKaP07Rp6h2rjYtZw@mail.gmail.com>
Subject: Re: Gain controls in v4l2-ctrl framework
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Chris MacGregor <chris@cybermato.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 26, 2012 at 1:24 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Wed, Sep 26, 2012 at 01:16:08PM +0530, Prabhakar Lad wrote:
> ...
>> Currently I am need of following,
>>
>>  1: V4L2_CID_GAIN_RED
>>  2: V4L2_CID_GAIN_GREEN_RED
>>  3: V4L2_CID_GAIN_GREEN_BLUE
>>  4: V4L2_CID_GAIN_BLUE
>>  5: V4L2_CID_GAIN_OFFSET
>
> Are they analogue or digital?
>
digital

Regards,
--Prabhakar

> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
