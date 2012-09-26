Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53494 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2IZGo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 02:44:58 -0400
Received: by obbuo13 with SMTP id uo13so236556obb.19
        for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 23:44:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 26 Sep 2012 12:14:36 +0530
Message-ID: <CA+V-a8v=_2vkuaYCAJNuyrqBX2bjU11KGASh7vkEQ4Qt2bFCGA@mail.gmail.com>
Subject: Re: Gain controls in v4l2-ctrl framework
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

On Sun, Sep 23, 2012 at 4:56 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi All,
>
> The CCD/Sensors have the capability to adjust the R/ye, Gr/Cy, Gb/G,
> B/Mg gain values.
> Since these control can be re-usable I am planning to add the
> following gain controls as part
> of the framework:
>
> 1: V4L2_CID_GAIN_RED
> 2: V4L2_CID_GAIN_GREEN_RED
> 3: V4L2_CID_GAIN_GREEN_BLUE
> 4: V4L2_CID_GAIN_BLUE
> 5: V4L2_CID_GAIN_OFFSET
>
> I need your opinion's to get moving to add them.
>

I am listing out the gain controls which is the outcome of above discussion:-

1: V4L2_CID_GAIN_RED
2: V4L2_CID_GAIN_GREEN_RED
3: V4L2_CID_GAIN_GREEN_BLUE
4: V4L2_CID_GAIN_BLUE
5: V4L2_CID_GAIN_OFFSET
6: V4L2_CID_BLUE_OFFSET
7: V4L2_CID_RED_OFFSET
8: V4L2_CID_GREEN_OFFSET

Please let me know for any addition/deletion.

Regards,
--Prabhakar Lad

> Thanks and Regards,
> --Prabhakar Lad
