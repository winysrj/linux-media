Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:42009 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZHKWRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 18:17:41 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>, "Yin, Paul" <zhenyin@ti.com>
Date: Tue, 11 Aug 2009 17:17:38 -0500
Subject: DM6467 VPIF adding support for HD resolution capture and display
 standards
Message-ID: <A69FA2915331DC488A831521EAE36FE401452885B1@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

We need to add support for HD resolutions capture and display in our DM6467 vpif drivers. The vpif display driver is already part of V4L-DVB linux-next
repository and capture driver is being reviewed. The next phase of our developments involve adding following HD resolutions for capture and display
drivers:-

720p@60, 720P@50, 1080i@30, 1080i@25.

We will also need to add EDTV resolutions such as 480p@30 & 576p25.

As you can see these standards are not currently available in videodev2.h. In the media controller RFC that you have proposed, this issue is being addressed. I am referring it at 

http://www.archivum.info/video4linux-list@redhat.com/2008-07/00371/RFC:_Add_support_to_query_and_change_connections_inside_a_media_device


Here is the description from the RFC....

<Snip>
In practice I would propose extending the v4l2_std_id with the common HDTV
formats, that will take care for most use cases. In addition a new ioctl has
to be introduced: VIDIOC_S_TIMINGS. This allows you to either specify a
v4l2_std_id or a full set of timings (front porch, back porch, sync width,
etc.). It should be extendable so that we can add additional timing formats
in the future.

The digital format of the data from the media processor to the encoders can
be set by calling S_STD or S_TIMINGS on the media processor device.
.......

Looks like we could extend the S_STD with new HD standards mentioned above.
Please let us know you latest thoughts on this so that we can send patches
to enhance the standards. As you might know, this is very critical for our developments.

Thanks and regards, 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

