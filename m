Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:43749 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbZKBQOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 11:14:43 -0500
Date: Mon, 2 Nov 2009 10:32:45 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: =?ISO-8859-15?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: Re: [PATCH 1/3] gspca pac7302/pac7311: simplify pac_find_sof
In-Reply-To: <4AEE720A.50101@freemail.hu>
Message-ID: <alpine.LNX.2.00.0911021016100.8213@banach.math.auburn.edu>
References: <4AEE04CB.5060802@freemail.hu> <alpine.LNX.2.00.0911012112421.7702@banach.math.auburn.edu> <4AEE720A.50101@freemail.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-376388635-1257179568=:8213"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-376388635-1257179568=:8213
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Mon, 2 Nov 2009, N�meth M�rton wrote:

> Theodore Kilgore wrote:
>>
>> On Sun, 1 Nov 2009, N�meth M�rton wrote:
>>> Remove struct sd dependency from pac_find_sof() function implementation.
>>> This step prepares separation of pac7302 and pac7311 specific parts of
>>> struct sd.
>> [...]
>> But here is the point. The sn9c2028 cameras have a structure which seems
>> similar to the mr97310a cameras. They use a similar decompression
>> algorithm. They have a similar frame header. Specifically, the sn9c2028
>> frame header starts with the five bytes
>>
>>                  0xff, 0xff, 0x00, 0xc4, 0xc4
>>
>> whereas the pac_common frame header starts with the five bytes
>>
>>                  0xff, 0xff, 0x00, 0xff, 0x96
>>
>> Right now, for my own use, I have written a file sn9c2028.h which
>> essentially duplicates the functionality of pac_common.h and contains a
>> function which searches for the sn9c2028 SOF marker instead of searching
>> for the pac SOF marker. Is this necessarily the good, permanent solution?
>> I am not so sure about that.
>
> I think the pac_find_sof() is a special case. To find a SOF sequence in
> a bigger buffer in general needs to first analyze the SOF sequence for
> repeated bytes. If there are repeated bytes the search have to be
> continued in a different way, see the state machine currently in the
> pac_common.h. To find the sn9c2028 frame header a different state machine
> is needed. It might be possible to implement a search function which
> can find any SOF sequence but I am afraid that this algorithm would be
> too complicated because of the search string analysis.

Well, I do not really know enough about this to be able to say something 
authoritative, but:

1. There is an obvious limitation on the length of the SOF marker. If it 
is agreed upon that the SOF marker is 5 bytes or less, then it ought not 
to be so terrible a thing to do. Namely, your state machine should accept 
an input, consisting of a pointer to the proper SOF marker and use that 
one instead of what is "hard wired" in your code. So, for example,

                 switch (sd->sof_read) {
                 case 0:
                         if (m[i] == 0xff)
                                 sd->sof_read = 1;
                         break;
                 case 1:
                         if (m[i] == 0xff)
                                 sd->sof_read = 2;
                         else
                                 sd->sof_read = 0;
                         break;
 			(and so on)

could read instead as

                 switch (sd->sof_read) {
                 case 0:
                         if (m[i] == sof_marker[0])
                                 sd->sof_read = 1;
                         break;
                 case 1:
                         if (m[i] == sof_marker[1])
                                 sd->sof_read = 2;
                         else
                                 sd->sof_read = 0;
                         break;
 			(and so on)


The problem would come if the SOF marker were six bytes long instead. The 
way to solve that would be to figure out what is the longest SOF marker 
that one wants to deal with, beforehand. I am not sure what is the 
prevailing number of bytes in such an SOF marker, or the maximum number. 
But it would be possible to prescribe some reasonable maximum number 
and take that into account, I think.

2. Although it seems to me it would not be a terribly big deal to code the 
above, there is the question whether it would significantly slow the 
algorithm down to be required to go and read the variable sof_marker[]. My 
instinct is that it would cost practically nothing to do that, but I am 
not the expert on such matters, which is why I put the disclaimer at the 
top. If somebody who knows what he is talking about says this idea causes 
a speed or timing problem, then forget about it. In that case it is better 
to have another function for every camera.

Theodore Kilgore
---863829203-376388635-1257179568=:8213--
