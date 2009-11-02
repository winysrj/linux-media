Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:53196 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZKBDhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 22:37:38 -0500
Date: Sun, 1 Nov 2009 21:43:13 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 1/3] gspca pac7302/pac7311: simplify pac_find_sof
In-Reply-To: <4AEE04CB.5060802@freemail.hu>
Message-ID: <alpine.LNX.2.00.0911012112421.7702@banach.math.auburn.edu>
References: <4AEE04CB.5060802@freemail.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-1087670364-1257133393=:7702"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-1087670364-1257133393=:7702
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Sun, 1 Nov 2009, Németh Márton wrote:

> From: Márton Németh <nm127@freemail.hu>
>
> Remove struct sd dependency from pac_find_sof() function implementation.
> This step prepares separation of pac7302 and pac7311 specific parts of
> struct sd.
>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> Cc: Thomas Kaiser <thomas@kaiser-linux.li>
> Cc: Theodore Kilgore <kilgota@auburn.edu>
> Cc: Kyle Guinn <elyk03@gmail.com>

<snip>

Szia Marton,

As long as these things work, I would not mind at all. But perhaps this is 
a good occasion to bring up an issue which seems to me very much related. 
It is the following:

Along with the (it seems to be never-ending) work on the mr97310a driver, 
I have been working on a driver for the sn9c2028 cameras. The driver at 
this point functions, and seems to function quite well. But it also seems 
to me that the code needs quite a bit of polishing before it is 
publicized. Since I have been very much preoccupied with finishing the 
mr97310a driver (why does the last 5% of a job sometimes take the most 
time?) this final polishing of the sn9c2028 driver has not yet occurred, 
sorry to say.

But here is the point. The sn9c2028 cameras have a structure which seems 
similar to the mr97310a cameras. They use a similar decompression 
algorithm. They have a similar frame header. Specifically, the sn9c2028 
frame header starts with the five bytes

                 0xff, 0xff, 0x00, 0xc4, 0xc4

whereas the pac_common frame header starts with the five bytes

                 0xff, 0xff, 0x00, 0xff, 0x96

Right now, for my own use, I have written a file sn9c2028.h which 
essentially duplicates the functionality of pac_common.h and contains a 
function which searches for the sn9c2028 SOF marker instead of searching 
for the pac SOF marker. Is this necessarily the good, permanent solution? 
I am not so sure about that.

Perhaps when making changes it is a good time to think over the idea of 
combining things which are in fact not very much different. After all, 
another set of cameras might come along, too, which essentially requires 
yet another minor variation on the same basic algorithm. Then we are 
supposed to have three .h files with three functions which have the same 
code and just search for slightly different strings?

I am well aware that you started out to do something different, but how 
does this strike you?


Theodore Kilgore
---863829203-1087670364-1257133393=:7702--
