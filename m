Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MIMNfx026815
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 14:22:23 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.235])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MIMCWO003615
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 14:22:12 -0400
Received: by wr-out-0506.google.com with SMTP id c57so1257762wra.9
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 11:22:12 -0700 (PDT)
Date: Tue, 22 Apr 2008 10:33:58 -0700
From: Brandon Philips <brandon@ifup.org>
To: Frej Drejhammar <frej.drejhammar@gmail.com>
Message-ID: <20080422173358.GJ7392@plankton.ifup.org>
References: <patchbomb.1206312199@liva.fdsoft.se>
	<20080421233441.GB24855@plankton.ifup.org>
	<kskxdu8pq.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kskxdu8pq.fsf@liva.fdsoft.se>
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

On 18:59 Tue 22 Apr 2008, Frej Drejhammar wrote:
> >> +	  <row>
> >> +            <entry><constant>V4L2_CID_COLOR_KILLER</constant></entry>
> >> +            <entry>boolean</entry>
> >> +            <entry>Enables color killer functionality.</entry>
> >> +          </row>
> >
> > Could we please get an explanation of what a color killer is for other
> > driver writers?
> 
> Sorry. From the current documentation I did not understand that
> standard functionality (AUTO_WHITE_BALANCE, DO_WHITE_BALANCE, GAIN)
> required a detailed description. 

Most people understand what WHITE_BALANCE and GAIN are, color killing is
a bit more abstract ;)

> A concise description of a color killer is as follows:

> The color killer disables color decoding if a color-burst is not
> present in the input signal. This avoids interference showing up as
> false color in purely black-and-white broadcasts (one where the
> broadcaster does not generate a color-burst).

Thanks.  I will add that to your doc patch and send it to Michael.

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
