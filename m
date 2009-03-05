Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:44230 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZCEFys (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 00:54:48 -0500
Received: by ewy25 with SMTP id 25so2905626ewy.37
        for <linux-media@vger.kernel.org>; Wed, 04 Mar 2009 21:54:44 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: kilgota@banach.math.auburn.edu
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
Date: Wed, 4 Mar 2009 23:54:40 -0600
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <20090217200928.1ae74819@free.fr> <200903042049.37829.elyk03@gmail.com> <alpine.LNX.2.00.0903042210500.23365@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903042210500.23365@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903042354.40787.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 March 2009 22:34:13 kilgota@banach.math.auburn.edu wrote:
> On Wed, 4 Mar 2009, Kyle Guinn wrote:
> > On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
> >> contents of file mr97310a.patch follow, for gspca/mr97310a.c
> >> --------------------------------------------------------
> >> --- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
> >> +++ mr97310a.c.new	2009-03-03 17:19:06.000000000 -0600
> >> @@ -302,21 +302,9 @@ static void sd_pkt_scan(struct gspca_dev
> >>   					data, n);
> >>   		sd->header_read = 0;
> >>   		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
> >> -		len -= sof - data;
> >> -		data = sof;
> >> -	}
> >> -	if (sd->header_read < 7) {
> >> -		int needed;
> >> -
> >> -		/* skip the rest of the header */
> >> -		needed = 7 - sd->header_read;
> >> -		if (len <= needed) {
> >> -			sd->header_read += len;
> >> -			return;
> >> -		}
> >> -		data += needed;
> >> -		len -= needed;
> >> -		sd->header_read = 7;
> >> +		/* keep the header, including sof marker, for coming frame */
> >> +		len -= n;
> >> +		data = sof - sizeof pac_sof_marker;;
> >>   	}
> >>
> >>   	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
> >
> > A few notes:
> >
> > 1.  There is an extra semicolon on that last added line.
>
> Oops. My bifocals.
>
> > 2.  sd->header_read no longer seems necessary.
>
> This is very likely true.
>
> > 3.  If the SOF marker is split over two transfers then everything falls
> > apart.
>
> Are you sure about that?
>

Simple example:  One transfer ends with FF FF 00 and the next begins with FF 
96 64.  pac_find_sof() returns a pointer to 64, n is set to 0, len stays the 
same, data now points at 3 bytes _before_ the transfer buffer, and we will 
most likely get undefined behavior when trying to copy the data out of the 
transfer buffer.  Not only that, but the FF FF 00 portion of the SOF won't 
get copied to the frame buffer.

Since we know what the SOF looks like, we don't need to worry about losing the 
FF FF 00 portion -- just copy sd->sof_read bytes from pac_sof_marker.  
Unfortunately my brain is fried right now and I can't come up with a working 
example.

> > I don't know if the camera will allow that to happen, but it's better to
> > be safe.
>
> Agreed.
>
> Note that this was a RFC. So if it is agreed that something needs to be
> done, probably things should be put into a more formal patch structure.
>
> Also I have a question of my own while thinking about this. It relates not
> to the module but to the decompression code. What do we have over there?
> Well,
>
> void v4lconvert_decode_mr97310a(const unsigned char *inp, unsigned char
> *outp,
>                                 int width, int height)
>
> and then in my patch it does
>
>          /* remove the header */
>          inp += 12;
>
> Perhaps this is not good, and what ought to be done instead is to "pass
> off" the inp to an internal variable, and then increase it, instead.
>
> Possibly an even better alternative exists. The easiest way, I think,
> would be to take the two previous lines back out again, but
> instead go back to the function
>
> static inline unsigned char get_byte(const unsigned char *inp,
>                                       unsigned int bitpos)
> {
>          const unsigned char *addr;
>          addr = inp + (bitpos >> 3);
>          return (addr[0] << (bitpos & 7)) | (addr[1] >> (8 - (bitpos &
> 7)));
> }
>
> and put the 12-byte shift into the line which computes addr, like this:
>
>          addr = inp + 12 + (bitpos >> 3);
>

Let's not overcomplicate things.  I think inp += 12 with a comment is fine for 
now since we haven't completely reverse engineered the header yet.  Use one 
function to parse through the header, then use a different one to handle the 
frame decompression.  The header parser will call the correct decompressor 
function with the correct offset into the frame buffer.

> or if one really wants to get fancy about it then give a
>
> #define MR97310a_HEADERSIZE	12
>
> at the top of the file and then one could say
>
>          addr = inp + (bitpos >> 3) + MR97310a_HEADERSIZE;
>

I don't think we know this for sure yet.  Maybe the header length is variable 
and is specified along with the compression code?

> As I said, if doing any of these then one would leave strictly alone the
> decoding function and any of its contents. I am not sure if messing with
> the start of the inp variable is a good idea. Frankly, I do not know
> enough details to be certain. But on second look my instincts are against
> screwing with something like that. The thing that worries me is that what
> exactly happens to those 12 bytes. Do they disappear down a black hole, or
> what? For, in the end they will have to be deallocated somewhere. And
> what then? The alternative which I give above would do what is needed and
> also does not mess with the start location of inp.
>

inp is a local variable, so changing it inside the decompressor function will 
have no affect on anything else.  inp += 12 just moves the pointer 12 bytes 
down the buffer.  The decompressor function doesn't allocate anything, so no 
deallocation is necessary.

-Kyle
