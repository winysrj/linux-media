Return-path: <linux-media-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:49612 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZCECto (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 21:49:44 -0500
Received: by nf-out-0910.google.com with SMTP id d21so706676nfb.21
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 18:49:41 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: kilgota@banach.math.auburn.edu
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
Date: Wed, 4 Mar 2009 20:49:37 -0600
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903042049.37829.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
> contents of file mr97310a.patch follow, for gspca/mr97310a.c
> --------------------------------------------------------
> --- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
> +++ mr97310a.c.new	2009-03-03 17:19:06.000000000 -0600
> @@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
>   					data, n);
>   		sd->header_read = 0;
>   		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
> -		len -= sof - data;
> -		data = sof;
> -	}
> -	if (sd->header_read < 7) {
> -		int needed;
> -
> -		/* skip the rest of the header */
> -		needed = 7 - sd->header_read;
> -		if (len <= needed) {
> -			sd->header_read += len;
> -			return;
> -		}
> -		data += needed;
> -		len -= needed;
> -		sd->header_read = 7;
> +		/* keep the header, including sof marker, for coming frame */
> +		len -= n;
> +		data = sof - sizeof pac_sof_marker;;
>   	}
>
>   	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);

A few notes:

1.  There is an extra semicolon on that last added line.
2.  sd->header_read no longer seems necessary.
3.  If the SOF marker is split over two transfers then everything falls apart.  
I don't know if the camera will allow that to happen, but it's better to be 
safe.

-Kyle
