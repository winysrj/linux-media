Return-path: <linux-media-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:8972 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZCFBWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 20:22:03 -0500
Received: by nf-out-0910.google.com with SMTP id d21so28072nfb.21
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 17:22:00 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: kilgota@banach.math.auburn.edu
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
Date: Thu, 5 Mar 2009 19:21:56 -0600
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <20090217200928.1ae74819@free.fr> <49B038D8.8060702@redhat.com> <alpine.LNX.2.00.0903051457410.27979@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903051457410.27979@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051921.57412.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 March 2009 14:58:54 kilgota@banach.math.auburn.edu wrote:
> Well, here is the code in the function. I don't see. So can you explain?
> Perhaps I am dense.
>
> {
>          struct sd *sd = (struct sd *) gspca_dev;
>          int i;
>
>          /* Search for the SOF marker (fixed part) in the header */
>          for (i = 0; i < len; i++) {
>                  if (m[i] == pac_sof_marker[sd->sof_read]) {
>                          sd->sof_read++;
>                          if (sd->sof_read == sizeof(pac_sof_marker)) {
>                                  PDEBUG(D_FRAM,
>                                          "SOF found, bytes to analyze: %u."
>                                          " Frame starts at byte #%u",
>                                          len, i + 1);
>                                  sd->sof_read = 0;
>                                  return m + i + 1;
>                          }
>                  } else {
>                          sd->sof_read = 0;
>                  }
>          }
>
>          return NULL;
> }

We send a chunk of data to this function, as pointed to by m.  It could be the 
entire transfer buffer or only a part of it, but that doesn't matter.  If the 
chunk of data ends with FF FF 00 then sd->sof_read will be set to 3 when the 
function exits.  On the next call it picks up where it left off and looks for 
byte 4 of the SOF.

Way back when, I said to copy sd->sof_read bytes from pac_sof_marker if you 
want the portion of the SOF that was in the previous transfer.  There's no 
need to buffer 4 bytes from the previous transfer because the SOF is 
_constant_.

So, if it's constant, why do we need to copy it to userspace at all?  If we 
do, then every frame buffer begins with a constant, useless FF FF 00 FF 96.  
The "reassurance" doesn't matter because the frame _must_ have started with 
FF FF 00 FF 96 to get there in the first place.  I agree with Hans that it 
isn't necessary, and by not sending it to userspace we simplify the kernel 
driver.

But what if it's not constant?  Maybe the SOF is 4 bytes and the 5th byte is 
some useful data that, 99.9% of the time, is set to 96?  This is the only 
reason I see for keeping the SOF.

-Kyle
