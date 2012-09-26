Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47956 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752809Ab2IZHyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 03:54:33 -0400
Date: Wed, 26 Sep 2012 10:54:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
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
Subject: Re: Gain controls in v4l2-ctrl framework
Message-ID: <20120926075427.GA14040@valkosipuli.retiisi.org.uk>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
 <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com>
 <20120926074240.GM12025@valkosipuli.retiisi.org.uk>
 <CA+V-a8vBXP=af_zWgiQzUhNBvexC6joddW7hioMqGziSTK9Dqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+V-a8vBXP=af_zWgiQzUhNBvexC6joddW7hioMqGziSTK9Dqw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 26, 2012 at 01:16:08PM +0530, Prabhakar Lad wrote:
...
> Currently I am need of following,
> 
>  1: V4L2_CID_GAIN_RED
>  2: V4L2_CID_GAIN_GREEN_RED
>  3: V4L2_CID_GAIN_GREEN_BLUE
>  4: V4L2_CID_GAIN_BLUE
>  5: V4L2_CID_GAIN_OFFSET

Are they analogue or digital?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
