Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:33145 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbZCEEXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 23:23:04 -0500
Date: Wed, 4 Mar 2009 22:34:13 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Kyle Guinn <elyk03@gmail.com>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
In-Reply-To: <200903042049.37829.elyk03@gmail.com>
Message-ID: <alpine.LNX.2.00.0903042210500.23365@banach.math.auburn.edu>
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903042049.37829.elyk03@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Mar 2009, Kyle Guinn wrote:

> On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
>> contents of file mr97310a.patch follow, for gspca/mr97310a.c
>> --------------------------------------------------------
>> --- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
>> +++ mr97310a.c.new	2009-03-03 17:19:06.000000000 -0600
>> @@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
>>   					data, n);
>>   		sd->header_read = 0;
>>   		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
>> -		len -= sof - data;
>> -		data = sof;
>> -	}
>> -	if (sd->header_read < 7) {
>> -		int needed;
>> -
>> -		/* skip the rest of the header */
>> -		needed = 7 - sd->header_read;
>> -		if (len <= needed) {
>> -			sd->header_read += len;
>> -			return;
>> -		}
>> -		data += needed;
>> -		len -= needed;
>> -		sd->header_read = 7;
>> +		/* keep the header, including sof marker, for coming frame */
>> +		len -= n;
>> +		data = sof - sizeof pac_sof_marker;;
>>   	}
>>
>>   	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
>
> A few notes:
>
> 1.  There is an extra semicolon on that last added line.

Oops. My bifocals.

> 2.  sd->header_read no longer seems necessary.

This is very likely true.

> 3.  If the SOF marker is split over two transfers then everything falls apart.

Are you sure about that?

> I don't know if the camera will allow that to happen, but it's better to be
> safe.

Agreed.

Note that this was a RFC. So if it is agreed that something needs to be 
done, probably things should be put into a more formal patch structure.

Also I have a question of my own while thinking about this. It relates not 
to the module but to the decompression code. What do we have over there? 
Well,

void v4lconvert_decode_mr97310a(const unsigned char *inp, unsigned char 
*outp,
                                int width, int height)

and then in my patch it does

         /* remove the header */
         inp += 12;

Perhaps this is not good, and what ought to be done instead is to "pass 
off" the inp to an internal variable, and then increase it, instead.

Possibly an even better alternative exists. The easiest way, I think, 
would be to take the two previous lines back out again, but 
instead go back to the function

static inline unsigned char get_byte(const unsigned char *inp,
                                      unsigned int bitpos)
{
         const unsigned char *addr;
         addr = inp + (bitpos >> 3);
         return (addr[0] << (bitpos & 7)) | (addr[1] >> (8 - (bitpos & 
7)));
}

and put the 12-byte shift into the line which computes addr, like this:

         addr = inp + 12 + (bitpos >> 3);

or if one really wants to get fancy about it then give a

#define MR97310a_HEADERSIZE	12

at the top of the file and then one could say

         addr = inp + (bitpos >> 3) + MR97310a_HEADERSIZE;

As I said, if doing any of these then one would leave strictly alone the 
decoding function and any of its contents. I am not sure if messing with 
the start of the inp variable is a good idea. Frankly, I do not know 
enough details to be certain. But on second look my instincts are against 
screwing with something like that. The thing that worries me is that what 
exactly happens to those 12 bytes. Do they disappear down a black hole, or 
what? For, in the end they will have to be deallocated somewhere. And 
what then? The alternative which I give above would do what is needed and 
also does not mess with the start location of inp.

Theodore Kilgore
