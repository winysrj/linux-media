Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3LNZ0cP012853
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 19:35:00 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3LNYmCt003448
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 19:34:48 -0400
Received: by ug-out-1314.google.com with SMTP id t39so814883ugd.6
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 16:34:47 -0700 (PDT)
Date: Mon, 21 Apr 2008 16:34:41 -0700
From: Brandon Philips <brandon@ifup.org>
To: Frej Drejhammar <frej.drejhammar@gmail.com>
Message-ID: <20080421233441.GB24855@plankton.ifup.org>
References: <patchbomb.1206312199@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1206312199@liva.fdsoft.se>
Cc: video4linux-list@redhat.com, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH 0 of 6] cx88: Enable additional cx2388x features.
	Version 3
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

On 23:43 Sun 23 Mar 2008, Frej Drejhammar wrote:
> +	  <row>
> +            <entry><constant>V4L2_CID_COLOR_KILLER</constant></entry>
> +            <entry>boolean</entry>
> +            <entry>Enables color killer functionality.</entry>
> +          </row>

Ok, so I found the doc patch but it isn't very helpful...

Could we please get an explanation of what a color killer is for other
driver writers?

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
