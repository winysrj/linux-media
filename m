Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3MH034A016301
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 13:00:03 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3MGxKOu016668
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 12:59:20 -0400
Received: by nf-out-0910.google.com with SMTP id g13so822309nfb.21
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 09:59:19 -0700 (PDT)
To: Brandon Philips <brandon@ifup.org>
From: Frej Drejhammar <frej.drejhammar@gmail.com>
In-Reply-To: <20080421233441.GB24855@plankton.ifup.org> (Brandon Philips's
	message of "Mon, 21 Apr 2008 16:34:41 -0700")
References: <patchbomb.1206312199@liva.fdsoft.se>
	<20080421233441.GB24855@plankton.ifup.org>
Date: Tue, 22 Apr 2008 18:59:13 +0200
Message-ID: <kskxdu8pq.fsf@liva.fdsoft.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

>> +	  <row>
>> +            <entry><constant>V4L2_CID_COLOR_KILLER</constant></entry>
>> +            <entry>boolean</entry>
>> +            <entry>Enables color killer functionality.</entry>
>> +          </row>
>
> Could we please get an explanation of what a color killer is for other
> driver writers?

Sorry. From the current documentation I did not understand that
standard functionality (AUTO_WHITE_BALANCE, DO_WHITE_BALANCE, GAIN)
required a detailed description. A concise description of a color
killer is as follows:

The color killer disables color decoding if a color-burst is not
present in the input signal. This avoids interference showing up as
false color in purely black-and-white broadcasts (one where the
broadcaster does not generate a color-burst).

Regards,

--Frej

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
