Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64759 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZKBFps (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 00:45:48 -0500
Message-ID: <4AEE720A.50101@freemail.hu>
Date: Mon, 02 Nov 2009 06:45:46 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 1/3] gspca pac7302/pac7311: simplify pac_find_sof
References: <4AEE04CB.5060802@freemail.hu> <alpine.LNX.2.00.0911012112421.7702@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0911012112421.7702@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Theodore Kilgore wrote:
> 
> On Sun, 1 Nov 2009, Németh Márton wrote:
>> Remove struct sd dependency from pac_find_sof() function implementation.
>> This step prepares separation of pac7302 and pac7311 specific parts of
>> struct sd.
> [...]
> But here is the point. The sn9c2028 cameras have a structure which seems 
> similar to the mr97310a cameras. They use a similar decompression 
> algorithm. They have a similar frame header. Specifically, the sn9c2028 
> frame header starts with the five bytes
> 
>                  0xff, 0xff, 0x00, 0xc4, 0xc4
> 
> whereas the pac_common frame header starts with the five bytes
> 
>                  0xff, 0xff, 0x00, 0xff, 0x96
> 
> Right now, for my own use, I have written a file sn9c2028.h which 
> essentially duplicates the functionality of pac_common.h and contains a 
> function which searches for the sn9c2028 SOF marker instead of searching 
> for the pac SOF marker. Is this necessarily the good, permanent solution? 
> I am not so sure about that.

I think the pac_find_sof() is a special case. To find a SOF sequence in
a bigger buffer in general needs to first analyze the SOF sequence for
repeated bytes. If there are repeated bytes the search have to be
continued in a different way, see the state machine currently in the
pac_common.h. To find the sn9c2028 frame header a different state machine
is needed. It might be possible to implement a search function which
can find any SOF sequence but I am afraid that this algorithm would be
too complicated because of the search string analysis.

> Perhaps when making changes it is a good time to think over the idea of 
> combining things which are in fact not very much different. After all, 
> another set of cameras might come along, too, which essentially requires 
> yet another minor variation on the same basic algorithm. Then we are 
> supposed to have three .h files with three functions which have the same 
> code and just search for slightly different strings?
> 
> I am well aware that you started out to do something different, but how 
> does this strike you?

I was also thinking about not just duplicate the code but find functions
which are similar. My thinking was that first I try to separate the
pac7302 and pac7311 subdrivers and get feedback. If this change was
accepted I would look for common functions not only in pac7302 and pac7311
but also in the gspca family of subdrivers.

My first candidate would be the low level reg_w*() and reg_r*() functions.
I haven't finished the analysis but it seems that most of the time the
usb_control_msg() parameters are the same except the request and
requesttype parameter. The request contains a number specific to the
device. The requesttype usually contains USB_RECIP_DEVICE or
USB_RECIP_INTERFACE. This means that these function can be extracted
to a common helper module or to gspca_main and introduce the request
and requesttype values somehow to struct sd_desc in gspca.h.

Regards,

	Márton Németh

