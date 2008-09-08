Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88KIWTa017032
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 16:18:32 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88KIJ38003663
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 16:18:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@nokia.com>
Date: Mon, 8 Sep 2008 22:18:14 +0200
References: <48C55737.4080804@nokia.com>
In-Reply-To: <48C55737.4080804@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082218.14332.hverkuil@xs4all.nl>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	"Zutshi Vimarsh \(Nokia-D-MSW/Helsinki\)" <vimarsh.zutshi@nokia.com>
Subject: Re: [PATCH 0/7] V4L changes for OMAP 3 camera
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Sakari,

On Monday 08 September 2008 18:47:51 Sakari Ailus wrote:
> Hi,
>
> This patchset extends V4L2 interface and especially v4l2-int-if
> somewhat. The new functionality is there to support the OMAP 3 camera
> driver.
>
> Our aim is to get these patches into v4l-dvb tree and further to
> Linus' tree. The OMAP 3 camera driver, which is dependent on these
> patches, is targeted to linux-omap tree through
> linux-omap@vger.kernel.org mailing list. It is unlikely that it would
> be useful (or even compile) without many of the changes in linux-omap
> tree.
>
> The patches apply against v4l-dvb, Linus' tree or linux-omap.
>
> Comments will be appreciated. :-)

Well, here they are:

Patch 1/7 seems to be missing in action. Can you post that one again?

Patch 2/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Patch 3/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Patch 4/7: I'm having problems with this one. Shouldn't it be better to 
make this a driver-private ioctl? And then that ioctl can actually 
return a struct containing those settings, rather than a eeprom dump. 
It is highly device specific, after all, so let the device extract and 
return the useful information instead of requiring an application to do 
that.

Patch 5/7: Please add the explanation regarding possible transitions as 
comments to the header. Also, why is the RESUME needed? You have three 
states: off, standby, on. Resume is not a state, it is a state 
transition. It seems out of place.

Patch 6/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Patch 7/7: Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Note: as I have stated in earlier posts, I'm not happy about having 
multiple interfaces for sensors (soc-camera vs v4l2-int-device). 
However, since there is no replacement available at the moment I'm not 
going to hold back this effort.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
