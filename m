Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2FAb4JI007969
	for <video4linux-list@redhat.com>; Mon, 15 Mar 2010 06:37:04 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id o2FAaoPM013691
	for <video4linux-list@redhat.com>; Mon, 15 Mar 2010 06:36:51 -0400
Date: Mon, 15 Mar 2010 11:36:45 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Carlos Lavin <carlos.lavin@vista-silicon.com>
Subject: Re: file format for YUV422
Message-ID: <20100315103645.GA4293@minime.bse>
References: <fe6fd5f61003150208i219c1233r274b6114b1b35f18@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <fe6fd5f61003150208i219c1233r274b6114b1b35f18@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, Mar 15, 2010 at 10:08:16AM +0100, Carlos Lavin wrote:
> I need a format file for yuv422, I want to develop an application for save
> the information about image.  somebody know which is the best format for
> YUV422?

The YUV4MPEG can carry planar YUV422.
See "man yuv4mpeg" after installing mjpegtools.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
