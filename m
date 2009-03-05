Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:56015 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbZCEUaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 15:30:39 -0500
Date: Thu, 5 Mar 2009 14:42:37 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <49B022FE.3050206@redhat.com>
Message-ID: <alpine.LNX.2.00.0903051345560.27979@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200903042049.37829.elyk03@gmail.com> <alpine.LNX.2.00.0903042210500.23365@banach.math.auburn.edu> <200903042354.40787.elyk03@gmail.com> <49AF78A0.1030508@redhat.com> <alpine.LNX.2.00.0903051232350.27780@banach.math.auburn.edu>
 <49B022FE.3050206@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 5 Mar 2009, Hans de Goede wrote:

>
>
> kilgota@banach.math.auburn.edu wrote:
>> 
>> 
>> On Thu, 5 Mar 2009, Hans de Goede wrote:
>> 
>>> 
>>> 
>>> Kyle Guinn wrote:
>>>> On Wednesday 04 March 2009 22:34:13 kilgota@banach.math.auburn.edu wrote:
>>>>> On Wed, 4 Mar 2009, Kyle Guinn wrote:
>>>>>> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
>>>>>>> contents of file mr97310a.patch follow, for gspca/mr97310a.c
>>>>>>> --------------------------------------------------------
>>>>>>> --- mr97310a.c.old    2009-02-23 23:59:07.000000000 -0600
>>>>>>> +++ mr97310a.c.new    2009-03-03 17:19:06.000000000 -0600
>>>>>>> @@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
>>>>>>>                       data, n);
>>>>>>>           sd->header_read = 0;
>>>>>>>           gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
>>>>>>> -        len -= sof - data;
>>>>>>> -        data = sof;
>>>>>>> -    }
>>>>>>> -    if (sd->header_read < 7) {
>>>>>>> -        int needed;
>>>>>>> -
>>>>>>> -        /* skip the rest of the header */
>>>>>>> -        needed = 7 - sd->header_read;
>>>>>>> -        if (len <= needed) {
>>>>>>> -            sd->header_read += len;
>>>>>>> -            return;
>>>>>>> -        }
>>>>>>> -        data += needed;
>>>>>>> -        len -= needed;
>>>>>>> -        sd->header_read = 7;
>>>>>>> +        /* keep the header, including sof marker, for coming frame */
>>>>>>> +        len -= n;
>>>>>>> +        data = sof - sizeof pac_sof_marker;;
>>>>>>>       }
>>>>>>>
>>>>>>>       gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
>>>>>> A few notes:
>>>>>> 
>>>>>> 1.  There is an extra semicolon on that last added line.
>>>>> Oops. My bifocals.
>>>>> 
>>>>>> 2.  sd->header_read no longer seems necessary.
>>>>> This is very likely true.
>>>>> 
>>>>>> 3.  If the SOF marker is split over two transfers then everything falls
>>>>>> apart.
>>>>> Are you sure about that?
>>>>> 
>>>> 
>>>> Simple example:  One transfer ends with FF FF 00 and the next begins with 
>>>> FF 96 64.  pac_find_sof() returns a pointer to 64, n is set to 0, len 
>>>> stays the same, data now points at 3 bytes _before_ the transfer buffer, 
>>>> and we will most likely get undefined behavior when trying to copy the 
>>>> data out of the transfer buffer.  Not only that, but the FF FF 00 portion 
>>>> of the SOF won't get copied to the frame buffer.
>>>> 
>>> 
>>> Good point, since we will always pass frames to userspace which start with 
>>> the
>>> sof, maybe we should just only pass the variable part of the header to 
>>> userspace?
>>> 
>>> That sure feels like the easiest solution to me.
>>> 
>>> Regards,
>>> 
>>> Hans
>>> 
>> 
>> Hans, that would not solve the problem. In fact, it appears to me that this 
>> problem was already inherent in the driver code before I proposed any 
>> patches at all.
>
> Erm, if I understood correctly (haven't looked yet) the driver is working
> with the sof detection from pac_common, which does work with a SOF split
> over multiple frames.

That is not my impression of what the code in pac_common is doing. That 
code, as I understand, is totally neutral about such things. What is does 
is to parse some data and search for an SOF marker, and if it finds such a 
thing then it declares the next byte after to be what it calls "sof". 
Specifically, there is the function

static unsigned char *pac_find_sof(struct gspca_dev *gspca_dev,
                                         unsigned char *m, int len)

and what it does is that it searches through unsigned char *m up to the 
extent declared in int len, looking for an SOF marker. If it finds one, 
then it returns the location of the next byte after the SOF marker has 
been successfully read.

What this function does not address in any way whatsoever is where the 
data which is called unsigned char *m came from. So, the problem is, if 
unsigned char *m is a single packet, or if it is what remains after some 
stuff from the head of the packet has previously been put away, then the 
danger is very much present that we are discussing. Namely, if the first 
part of an SOF marker is present at the end of the data being considered 
and the rest of the SOF marker is in the next packet of data which is not 
yet being considered, then this function from pac_common, if naively 
applied, will miss the SOF marker completely. By its nature, this function 
can not search data which was not yet presented to it. That is the 
problem.

Therefore, if one must make sure the SOF marker is always detected, even 
if it is split across two packets, then any application of this function 
is buggy, which does not take into account the fact that one can run out 
of data before detecting an SOF marker, even when part of it is there at 
the very end of the data, or if an incomplete part of it is there at the 
very beginning of the data it will equally be missed. This remark would 
potentially apply to any camera driver which is using this function, not 
just the mr97310a driver.  Again, the pac_find_sof() function does not 
deal with _this_ issue, at all. It is up to the user of it to code around 
any potential problem of this sort.

The only way to avoid any possible occurrence of the problem is to 
follow my suggestion number two. One must keep four bytes from the end of 
a packet, and adjoin to that four bytes from the beginning of a new 
packet, and search those eight bytes, too, for an SOF marker. That is the 
only way to be sure of not missing an SOF marker which is split across 
two packets.

>
> The problem with the new code is that it takes the return value of the sof
> detection (which is a pointer into the current frame) and then
> substracts the length of the sofmarker, however if only part of the sof was
> in the current frame the resulting pointer (after substracting the sof 
> length)
> will point to before the current frame buffer.

That would be a bad thing if it could happen. But it can't happen. What 
will have happened instead is that the SOF marker has not been detected, 
at all. Now, if that is also a bad thing, then something ought to be done 
about it. But the nightmare scenario that you describe can not occur, at 
least without violating logic.

>
> Hence my proposal to fix this by simple only sending the variable part of the
> header to userspace (and thus not do the substraction).

Again, you have to have the entire SOF marker within the present packet 
before you can detect it. Otherwise, it will not be detected. This is not 
because of a failure of pac_find_sof(), but it is a question of what data 
was given to pac_find_sof(), to be searched. If you give it a packet to 
search which has FF FF 00 at the end of it, then it will not find an SOF 
marker in that packet. And if the next packet starts with FF 96, then it 
obviously can not find any SOF marker there, either. And when you fed to 
pac_find_sof() the new packet it is not the business of pac_find_sof() to 
remember that the old packet ended with FF FF 00. So it won't remember 
that. No. Instead, it is up to the programmer who is using pac_find_sof() 
to accunt for this possibility. And if the issue is crucial, fix it. As I 
said, the way to fix it is to keep the last four bytes of the first packet 
and the first four bytes of the second packet, and then search that little 
area separately. If it does not contain any SOF marker, then proceed. If 
it does, then use it. Then and only then, one might indeed be using data 
from the first packet and the second packet at the same time. But if the 
code is written right there is no problem.

>
> Anyways this is just what I understood from the former discussion I have 
> *not*
> looked at the actual code (-ENOTIME)

We all suffer from that, sometimes. Me, too. But if you look at the code 
for pac_find_sof() over in pac_common.h then I strongly suspect that you 
will have to agree with what I said here.

Theodore Kilgore
