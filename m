Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48195 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754165Ab2IZTXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 15:23:05 -0400
Message-ID: <50635616.8090605@iki.fi>
Date: Wed, 26 Sep 2012 22:23:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Chris MacGregor <chris@cybermato.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: Gain controls in v4l2-ctrl framework
References: <CA+V-a8vYDFhJzKVKsv7Q_JOQzDDYRyev15jDKio0tG2CP8iCCw@mail.gmail.com> <20120926074240.GM12025@valkosipuli.retiisi.org.uk> <50631461.7080903@cybermato.com> <1703218.fEdZSF7M3x@avalon>
In-Reply-To: <1703218.fEdZSF7M3x@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Chris,

Laurent Pinchart wrote:
> On Wednesday 26 September 2012 07:42:41 Chris MacGregor wrote:
...
>> Sorry to make this more complicated, but the Aptina MT9P031, for
>> instance (datasheet at
>> http://www.aptina.com/assets/downloadDocument.do?id=865 - see page 35),
>> has Digital Gain, an Analog Multiplier, and Analog Gain (for each of R,
>> Gr, Gb, and B). For each color channel, there is one register, with the
>> bits divided up into the three gain types. Furthermore, the different
>> gain types have different units (increments).
>>
>> Currently (at least in the last version I've used), the driver hides all
>> this and provides a single gain control, and prioritizes which gain
>> types are adjusted at different user-level gain settings in accordance
>> with the datasheet recommendations (e.g. keep the analog gain between 1
>> and 4 for best noise performance, and use the multiplier for gains
>> between 4 and 8). This seems very sensible.
>
> I think it should be fine for now. If we later find out that a user space
> application really needs to control the analog and digital gains individually
> and precisely we can always split the controls then. For now I think a single
> gain control (per channel) that groups analog and digital gains should be
> enough.

Agreed. I think there's much less reason to keep them separate for 
per-colour controls (compared to global gain), so little it's probably 
not worth it.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
