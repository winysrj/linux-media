Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56CI7ZP011941
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 08:18:07 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m56CHgs3005301
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 08:17:42 -0400
Date: Fri, 6 Jun 2008 14:17:19 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Linos <info@linos.es>
Message-ID: <20080606121719.GA506@daniel.bse>
References: <484920B9.4010107@linos.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484920B9.4010107@linos.es>
Cc: video4linux-list@redhat.com
Subject: Re: bttv driver problem last kernels
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

On Fri, Jun 06, 2008 at 01:34:17PM +0200, Linos wrote:
> Hello all,
> 	i am using a bttv multicapture board and i have been having 
> 	increasing problems in last kernels, i am using two programs to capture my 
> video input for security reasons (helix producer and mp4live from mpeg4ip 
> project) since the first versions of v4l2 in 2.4 patched kernel versions i 
> can attach the two programs at the same time at the same video input, only 
> loss framerate

You are relying on undocumented behaviour when two v4l1 applications are
reading from bttv at the same time. Furthermore the v4l2 standards says

"1.1.4. Shared Data Streams

V4L2 drivers should not support multiple applications reading or writing
the same data stream on a device by copying buffers, time multiplexing
or similar means. This is better handled by a proxy application in user
space. When the driver supports stream sharing anyway it must be
implemented transparently. The V4L2 API does not specify how conflicts
are solved."

You should change your setup to use only one application accessing the
device.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
