Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:58872 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZCFBq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 20:46:26 -0500
Date: Thu, 5 Mar 2009 19:57:48 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Kyle Guinn <elyk03@gmail.com>
cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200903051921.57412.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0903051935500.28461@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <49B038D8.8060702@redhat.com> <alpine.LNX.2.00.0903051457410.27979@banach.math.auburn.edu> <200903051921.57412.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Mar 2009, Kyle Guinn wrote:

> On Thursday 05 March 2009 14:58:54 kilgota@banach.math.auburn.edu wrote:
>> Well, here is the code in the function. I don't see. So can you explain?
>> Perhaps I am dense.
>>
>> {
>>          struct sd *sd = (struct sd *) gspca_dev;
>>          int i;
>>
>>          /* Search for the SOF marker (fixed part) in the header */
>>          for (i = 0; i < len; i++) {
>>                  if (m[i] == pac_sof_marker[sd->sof_read]) {
>>                          sd->sof_read++;
>>                          if (sd->sof_read == sizeof(pac_sof_marker)) {
>>                                  PDEBUG(D_FRAM,
>>                                          "SOF found, bytes to analyze: %u."
>>                                          " Frame starts at byte #%u",
>>                                          len, i + 1);
>>                                  sd->sof_read = 0;
>>                                  return m + i + 1;
>>                          }
>>                  } else {
>>                          sd->sof_read = 0;
>>                  }
>>          }
>>
>>          return NULL;
>> }
>
> We send a chunk of data to this function, as pointed to by m.  It could be the
> entire transfer buffer or only a part of it, but that doesn't matter.  If the
> chunk of data ends with FF FF 00 then sd->sof_read will be set to 3 when the
> function exits.  On the next call it picks up where it left off and looks for
> byte 4 of the SOF.

It took me a while to see this, but, yes. So I agree that something needed 
to be fixed. It is fixed, now. There is a revised patch.

>
> Way back when, I said to copy sd->sof_read bytes from pac_sof_marker if you
> want the portion of the SOF that was in the previous transfer.  There's no
> need to buffer 4 bytes from the previous transfer because the SOF is
> _constant_.

True. So this is the solution which is just now adopted.

>
> So, if it's constant, why do we need to copy it to userspace at all?  If we
> do, then every frame buffer begins with a constant, useless FF FF 00 FF 96.
> The "reassurance" doesn't matter because the frame _must_ have started with
> FF FF 00 FF 96 to get there in the first place.

Unless it was a frame from some other camera. But it could have been a 
frame dumped from some other camera, and then potentially useful 
information for evaluating what it is, would have been lost.

I agree with Hans that it
> isn't necessary, and by not sending it to userspace we simplify the kernel
> driver.

My experience indicates otherwise. One of the reasons for doing this is, 
if one has _all_ of this information it is easier to recognize where it 
came from. What kind of camera. What kind of compression. That kind of 
thing. It then becomes possible to do things such as to look 
at a raw file in total isolation from the streaming app, six months later, 
and to be able to know immediately what kind of camera it came from, and 
all other information relevant for processing it on the spot with a 
program which converts raw data into finished frames or images. If only it 
were possible to embed the width and height, somehow, into the header, 
then my happiness would be total.


>
> But what if it's not constant?  Maybe the SOF is 4 bytes and the 5th byte is
> some useful data that, 99.9% of the time, is set to 96?  This is the only
> reason I see for keeping the SOF.

Very good point. It could happen, couldn't it? It already occurred to me, 
actually. We do not know that it will not happen. For, in such a situation 
we are at the mercy of some other guys who make cameras. So why paint 
oneself into a corner and be sorry later on?

Theodore Kilgore
