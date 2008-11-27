Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARCckIV019949
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 07:38:46 -0500
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARCcXnH013459
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 07:38:33 -0500
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081127120536.62b35cd6.ospite@studenti.unina.it>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
	<20081127120536.62b35cd6.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 27 Nov 2008 13:22:33 +0100
Message-Id: <1227788553.1752.42.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca_ov534: Print only frame_rate actually used.
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

On Thu, 2008-11-27 at 12:05 +0100, Antonio Ospite wrote:
> > The patch also includes removing the bulk_size setting at streamon time:
> > the value is already used at this time, and also, there is only one
> > resolution.
> We will add this again when we add other resolutions, OK.

The bulk_size must be set at the max resolution because it is used for
buffer allocation before stream on.

	[snip]
> >  /* V4L2 controls supported by the driver */
> > @@ -59,7 +58,7 @@
> >  	{640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
> >  	 .bytesperline = 640 * 2,
> >  	 .sizeimage = 640 * 480 * 2,
> > -	 .colorspace = V4L2_COLORSPACE_JPEG,
> > +	 .colorspace = V4L2_COLORSPACE_SRGB,
> >  	 .priv = 0},
> >  };
> >
> 
> Can you explain this one, please?

I think the JPEG images embed colorspace information, and here, it is
simple RGB.

> [snip]
> > @@ -433,7 +429,6 @@
> >  	int framesize = gspca_dev->cam.bulk_size;
> >  
> >  	if (len == framesize - 4) {
> > -		frame =
> >  		    gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, len);
> 
> This change is just to follow the convention used by other drivers,
> right? You could also adjust indentation on following line, then.

If you look carefully, the frame returned by gspca_frame_add() is
changed only when the packet type is LAST_PACKET. OK for the
indentation.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
